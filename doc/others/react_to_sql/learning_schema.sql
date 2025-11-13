-- =====================================================
-- SCHEMA SQL PARA SISTEMA DE APRENDIZADO
-- Baseado em: lovable/src/pages/Learning.tsx
-- Data: 2025-10-11
-- Padrão: 3NF (Terceira Forma Normal)
-- =====================================================

-- =====================================================
-- FASE 1: MAPEAMENTO DE DADOS - RESUMO
-- =====================================================
-- ✅ Estruturas identificadas:
--    - Videos com 30 registros
--    - Categorias: Higiene, Alimentação, Mobilidade, Dor, Dispositivos, Fim de Vida, Respiração, Sintomas
--    - Seções: Cuidados Básicos, Mobilidade, Controle de Sintomas, Fim de Vida, Dispositivos
--    - Instrutores com especialidades (Enf., Fisio., Nutr., Dr., Psic.)
--    - Sistema de badges (ESSENCIAL, NOVO)
--    - Progresso do usuário (para Você, Biblioteca)
--
-- ✅ Relacionamentos identificados:
--    - Videos → Categories (N:1)
--    - Videos → Instructors (N:1)
--    - Videos → Sections (N:1)
--    - Users → Videos (N:N) - progresso, favoritos, histórico
--
-- ✅ Lógica de negócio:
--    - Sistema de recomendações personalizadas
--    - Histórico de vídeos assistidos
--    - Biblioteca de favoritos
--    - Busca por procedimentos
--    - Contagem de vídeos por categoria
-- =====================================================

-- =====================================================
-- 1. ENUMS
-- =====================================================

-- Tipo de profissional instrutor
CREATE TYPE instructor_type AS ENUM (
  'nurse',          -- Enfermeiro(a)
  'physiotherapist', -- Fisioterapeuta
  'nutritionist',   -- Nutricionista
  'doctor',         -- Médico(a)
  'psychologist'    -- Psicólogo(a)
);

-- Badge/etiqueta especial do vídeo
CREATE TYPE video_badge AS ENUM (
  'essential',  -- ESSENCIAL
  'new',        -- NOVO
  'popular',    -- POPULAR
  'advanced'    -- AVANÇADO
);

-- Status de progresso do vídeo
CREATE TYPE watch_status AS ENUM (
  'not_started',  -- Não iniciado
  'in_progress',  -- Em progresso
  'completed'     -- Completo
);

-- =====================================================
-- 2. TABELAS PRINCIPAIS
-- =====================================================

-- -----------------------------------------------------
-- Tabela: categories
-- Descrição: Categorias de vídeos educacionais
-- -----------------------------------------------------
CREATE TABLE categories (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(100) NOT NULL UNIQUE,
  slug VARCHAR(100) NOT NULL UNIQUE,
  description TEXT,
  icon_name VARCHAR(50), -- Nome do ícone Lucide (Droplet, Activity, etc)
  display_order INTEGER NOT NULL DEFAULT 0,
  is_active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Comentários das colunas
COMMENT ON TABLE categories IS 'Categorias de procedimentos de cuidados paliativos';
COMMENT ON COLUMN categories.slug IS 'Identificador amigável para URLs';
COMMENT ON COLUMN categories.icon_name IS 'Nome do ícone da biblioteca Lucide React';
COMMENT ON COLUMN categories.display_order IS 'Ordem de exibição na interface';

-- Índices
CREATE INDEX idx_categories_slug ON categories(slug);
CREATE INDEX idx_categories_active_order ON categories(is_active, display_order);

-- -----------------------------------------------------
-- Tabela: sections
-- Descrição: Seções organizacionais para agrupamento de vídeos
-- -----------------------------------------------------
CREATE TABLE sections (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(150) NOT NULL,
  slug VARCHAR(150) NOT NULL UNIQUE,
  subtitle TEXT,
  description TEXT,
  display_order INTEGER NOT NULL DEFAULT 0,
  is_active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Comentários
COMMENT ON TABLE sections IS 'Seções de organização de conteúdo (ex: Cuidados Básicos, Mobilidade)';
COMMENT ON COLUMN sections.subtitle IS 'Subtítulo descritivo da seção';

-- Índices
CREATE INDEX idx_sections_slug ON sections(slug);
CREATE INDEX idx_sections_active_order ON sections(is_active, display_order);

-- -----------------------------------------------------
-- Tabela: instructors
-- Descrição: Profissionais instrutores dos vídeos
-- -----------------------------------------------------
CREATE TABLE instructors (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  full_name VARCHAR(200) NOT NULL,
  professional_title VARCHAR(100), -- Ex: "Enf.", "Fisio.", "Dr."
  type instructor_type NOT NULL,
  bio TEXT,
  avatar_url TEXT,
  email VARCHAR(255),
  is_active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Comentários
COMMENT ON TABLE instructors IS 'Profissionais de saúde que ministram os procedimentos';
COMMENT ON COLUMN instructors.professional_title IS 'Título profissional abreviado (Enf., Dr., etc)';
COMMENT ON COLUMN instructors.type IS 'Tipo de profissional da saúde';

-- Índices
CREATE INDEX idx_instructors_type ON instructors(type);
CREATE INDEX idx_instructors_active ON instructors(is_active);

-- -----------------------------------------------------
-- Tabela: videos
-- Descrição: Vídeos educacionais de procedimentos
-- -----------------------------------------------------
CREATE TABLE videos (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  
  -- Identificação
  title VARCHAR(255) NOT NULL,
  subtitle TEXT,
  slug VARCHAR(255) NOT NULL UNIQUE,
  
  -- Relacionamentos
  category_id UUID NOT NULL REFERENCES categories(id) ON DELETE RESTRICT,
  section_id UUID REFERENCES sections(id) ON DELETE SET NULL,
  instructor_id UUID REFERENCES instructors(id) ON DELETE SET NULL,
  
  -- Conteúdo
  description TEXT,
  duration_minutes INTEGER NOT NULL CHECK (duration_minutes > 0),
  video_url TEXT NOT NULL,
  thumbnail_url TEXT,
  transcript TEXT,
  
  -- Metadata
  badge video_badge,
  is_new BOOLEAN NOT NULL DEFAULT false,
  is_featured BOOLEAN NOT NULL DEFAULT false,
  difficulty_level INTEGER CHECK (difficulty_level BETWEEN 1 AND 5),
  
  -- Estatísticas
  view_count INTEGER NOT NULL DEFAULT 0,
  average_rating DECIMAL(3,2) CHECK (average_rating BETWEEN 0 AND 5),
  rating_count INTEGER NOT NULL DEFAULT 0,
  
  -- Status
  is_published BOOLEAN NOT NULL DEFAULT false,
  published_at TIMESTAMPTZ,
  is_active BOOLEAN NOT NULL DEFAULT true,
  
  -- Auditoria
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  
  -- Busca full-text
  search_vector tsvector
);

-- Comentários
COMMENT ON TABLE videos IS 'Vídeos educacionais de procedimentos de cuidados paliativos';
COMMENT ON COLUMN videos.duration_minutes IS 'Duração do vídeo em minutos';
COMMENT ON COLUMN videos.badge IS 'Etiqueta especial (ESSENCIAL, NOVO, etc)';
COMMENT ON COLUMN videos.is_new IS 'Flag para destacar vídeos recentes';
COMMENT ON COLUMN videos.is_featured IS 'Vídeo em destaque na home';
COMMENT ON COLUMN videos.difficulty_level IS 'Nível de dificuldade: 1=Básico, 5=Avançado';
COMMENT ON COLUMN videos.search_vector IS 'Vetor para busca full-text otimizada';

-- Índices
CREATE INDEX idx_videos_category ON videos(category_id);
CREATE INDEX idx_videos_section ON videos(section_id);
CREATE INDEX idx_videos_instructor ON videos(instructor_id);
CREATE INDEX idx_videos_published ON videos(is_published, published_at);
CREATE INDEX idx_videos_active ON videos(is_active);
CREATE INDEX idx_videos_slug ON videos(slug);
CREATE INDEX idx_videos_badge ON videos(badge) WHERE badge IS NOT NULL;
CREATE INDEX idx_videos_is_new ON videos(is_new) WHERE is_new = true;

-- Índice para busca full-text
CREATE INDEX idx_videos_search ON videos USING GIN(search_vector);

-- Trigger para atualizar search_vector automaticamente
CREATE OR REPLACE FUNCTION videos_search_vector_update() RETURNS TRIGGER AS $$
BEGIN
  NEW.search_vector := 
    setweight(to_tsvector('portuguese', COALESCE(NEW.title, '')), 'A') ||
    setweight(to_tsvector('portuguese', COALESCE(NEW.subtitle, '')), 'B') ||
    setweight(to_tsvector('portuguese', COALESCE(NEW.description, '')), 'C');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_videos_search_vector_update
  BEFORE INSERT OR UPDATE OF title, subtitle, description
  ON videos
  FOR EACH ROW
  EXECUTE FUNCTION videos_search_vector_update();

-- Trigger para atualizar updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column() RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_videos_updated_at
  BEFORE UPDATE ON videos
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- -----------------------------------------------------
-- Tabela: video_tags
-- Descrição: Tags/palavras-chave para vídeos
-- -----------------------------------------------------
CREATE TABLE video_tags (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(100) NOT NULL UNIQUE,
  slug VARCHAR(100) NOT NULL UNIQUE,
  usage_count INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE video_tags IS 'Tags para categorização adicional de vídeos';
COMMENT ON COLUMN video_tags.usage_count IS 'Contador de quantos vídeos usam esta tag';

CREATE INDEX idx_video_tags_slug ON video_tags(slug);

-- =====================================================
-- 3. TABELAS DE RELACIONAMENTO
-- =====================================================

-- -----------------------------------------------------
-- Tabela: videos_tags (N:N)
-- Descrição: Relacionamento entre vídeos e tags
-- -----------------------------------------------------
CREATE TABLE videos_tags (
  video_id UUID NOT NULL REFERENCES videos(id) ON DELETE CASCADE,
  tag_id UUID NOT NULL REFERENCES video_tags(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  
  PRIMARY KEY (video_id, tag_id)
);

COMMENT ON TABLE videos_tags IS 'Relacionamento N:N entre vídeos e tags';

CREATE INDEX idx_videos_tags_video ON videos_tags(video_id);
CREATE INDEX idx_videos_tags_tag ON videos_tags(tag_id);

-- Trigger para atualizar usage_count
CREATE OR REPLACE FUNCTION update_tag_usage_count() RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    UPDATE video_tags SET usage_count = usage_count + 1 WHERE id = NEW.tag_id;
  ELSIF TG_OP = 'DELETE' THEN
    UPDATE video_tags SET usage_count = usage_count - 1 WHERE id = OLD.tag_id;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_tag_usage_count
  AFTER INSERT OR DELETE ON videos_tags
  FOR EACH ROW
  EXECUTE FUNCTION update_tag_usage_count();

-- -----------------------------------------------------
-- Tabela: user_video_progress
-- Descrição: Progresso do usuário em cada vídeo
-- -----------------------------------------------------
CREATE TABLE user_video_progress (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  video_id UUID NOT NULL REFERENCES videos(id) ON DELETE CASCADE,
  
  -- Progresso
  watch_status watch_status NOT NULL DEFAULT 'not_started',
  progress_seconds INTEGER NOT NULL DEFAULT 0 CHECK (progress_seconds >= 0),
  progress_percentage DECIMAL(5,2) NOT NULL DEFAULT 0.00 CHECK (progress_percentage BETWEEN 0 AND 100),
  
  -- Datas
  started_at TIMESTAMPTZ,
  completed_at TIMESTAMPTZ,
  last_watched_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  
  -- Metadata
  watch_count INTEGER NOT NULL DEFAULT 1,
  
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  
  UNIQUE(user_id, video_id)
);

COMMENT ON TABLE user_video_progress IS 'Progresso de visualização de vídeos por usuário';
COMMENT ON COLUMN user_video_progress.progress_seconds IS 'Segundos assistidos do vídeo';
COMMENT ON COLUMN user_video_progress.progress_percentage IS 'Porcentagem de conclusão (0-100)';
COMMENT ON COLUMN user_video_progress.watch_count IS 'Número de vezes que o usuário assistiu';

CREATE INDEX idx_user_video_progress_user ON user_video_progress(user_id);
CREATE INDEX idx_user_video_progress_video ON user_video_progress(video_id);
CREATE INDEX idx_user_video_progress_status ON user_video_progress(watch_status);
CREATE INDEX idx_user_video_progress_last_watched ON user_video_progress(user_id, last_watched_at DESC);

CREATE TRIGGER trigger_user_video_progress_updated_at
  BEFORE UPDATE ON user_video_progress
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- -----------------------------------------------------
-- Tabela: user_video_favorites
-- Descrição: Biblioteca de vídeos favoritos do usuário
-- -----------------------------------------------------
CREATE TABLE user_video_favorites (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  video_id UUID NOT NULL REFERENCES videos(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  
  UNIQUE(user_id, video_id)
);

COMMENT ON TABLE user_video_favorites IS 'Vídeos salvos na biblioteca do usuário';

CREATE INDEX idx_user_video_favorites_user ON user_video_favorites(user_id);
CREATE INDEX idx_user_video_favorites_video ON user_video_favorites(video_id);
CREATE INDEX idx_user_video_favorites_created ON user_video_favorites(user_id, created_at DESC);

-- -----------------------------------------------------
-- Tabela: user_video_ratings
-- Descrição: Avaliações de vídeos pelos usuários
-- -----------------------------------------------------
CREATE TABLE user_video_ratings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  video_id UUID NOT NULL REFERENCES videos(id) ON DELETE CASCADE,
  rating INTEGER NOT NULL CHECK (rating BETWEEN 1 AND 5),
  review TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  
  UNIQUE(user_id, video_id)
);

COMMENT ON TABLE user_video_ratings IS 'Avaliações e reviews de vídeos pelos usuários';
COMMENT ON COLUMN user_video_ratings.rating IS 'Nota de 1 a 5 estrelas';

CREATE INDEX idx_user_video_ratings_user ON user_video_ratings(user_id);
CREATE INDEX idx_user_video_ratings_video ON user_video_ratings(video_id);
CREATE INDEX idx_user_video_ratings_rating ON user_video_ratings(video_id, rating);

CREATE TRIGGER trigger_user_video_ratings_updated_at
  BEFORE UPDATE ON user_video_ratings
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Trigger para atualizar estatísticas de rating no vídeo
CREATE OR REPLACE FUNCTION update_video_rating_stats() RETURNS TRIGGER AS $$
BEGIN
  UPDATE videos
  SET 
    average_rating = (
      SELECT ROUND(AVG(rating)::numeric, 2)
      FROM user_video_ratings
      WHERE video_id = COALESCE(NEW.video_id, OLD.video_id)
    ),
    rating_count = (
      SELECT COUNT(*)
      FROM user_video_ratings
      WHERE video_id = COALESCE(NEW.video_id, OLD.video_id)
    )
  WHERE id = COALESCE(NEW.video_id, OLD.video_id);
  
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_video_rating_stats
  AFTER INSERT OR UPDATE OR DELETE ON user_video_ratings
  FOR EACH ROW
  EXECUTE FUNCTION update_video_rating_stats();

-- =====================================================
-- 4. ROW LEVEL SECURITY (RLS)
-- =====================================================

-- Habilitar RLS nas tabelas
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE sections ENABLE ROW LEVEL SECURITY;
ALTER TABLE instructors ENABLE ROW LEVEL SECURITY;
ALTER TABLE videos ENABLE ROW LEVEL SECURITY;
ALTER TABLE video_tags ENABLE ROW LEVEL SECURITY;
ALTER TABLE videos_tags ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_video_progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_video_favorites ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_video_ratings ENABLE ROW LEVEL SECURITY;

-- -----------------------------------------------------
-- Políticas para: categories
-- -----------------------------------------------------
-- Todos podem ver categorias ativas
CREATE POLICY "Categories are viewable by everyone"
  ON categories FOR SELECT
  USING (is_active = true);

-- Apenas admins podem modificar
CREATE POLICY "Only admins can modify categories"
  ON categories FOR ALL
  USING (auth.jwt() ->> 'role' = 'admin');

-- -----------------------------------------------------
-- Políticas para: sections
-- -----------------------------------------------------
CREATE POLICY "Sections are viewable by everyone"
  ON sections FOR SELECT
  USING (is_active = true);

CREATE POLICY "Only admins can modify sections"
  ON sections FOR ALL
  USING (auth.jwt() ->> 'role' = 'admin');

-- -----------------------------------------------------
-- Políticas para: instructors
-- -----------------------------------------------------
CREATE POLICY "Active instructors are viewable by everyone"
  ON instructors FOR SELECT
  USING (is_active = true);

CREATE POLICY "Only admins can modify instructors"
  ON instructors FOR ALL
  USING (auth.jwt() ->> 'role' = 'admin');

-- -----------------------------------------------------
-- Políticas para: videos
-- -----------------------------------------------------
-- Todos podem ver vídeos publicados e ativos
CREATE POLICY "Published videos are viewable by everyone"
  ON videos FOR SELECT
  USING (is_published = true AND is_active = true);

-- Admins podem ver todos os vídeos
CREATE POLICY "Admins can view all videos"
  ON videos FOR SELECT
  USING (auth.jwt() ->> 'role' = 'admin');

-- Apenas admins podem modificar
CREATE POLICY "Only admins can modify videos"
  ON videos FOR ALL
  USING (auth.jwt() ->> 'role' = 'admin');

-- -----------------------------------------------------
-- Políticas para: video_tags
-- -----------------------------------------------------
CREATE POLICY "Tags are viewable by everyone"
  ON video_tags FOR SELECT
  USING (true);

CREATE POLICY "Only admins can modify tags"
  ON video_tags FOR ALL
  USING (auth.jwt() ->> 'role' = 'admin');

-- -----------------------------------------------------
-- Políticas para: videos_tags
-- -----------------------------------------------------
CREATE POLICY "Video tags are viewable by everyone"
  ON videos_tags FOR SELECT
  USING (true);

CREATE POLICY "Only admins can modify video tags"
  ON videos_tags FOR ALL
  USING (auth.jwt() ->> 'role' = 'admin');

-- -----------------------------------------------------
-- Políticas para: user_video_progress
-- -----------------------------------------------------
-- Usuários podem ver apenas seu próprio progresso
CREATE POLICY "Users can view own progress"
  ON user_video_progress FOR SELECT
  USING (auth.uid() = user_id);

-- Usuários podem inserir seu próprio progresso
CREATE POLICY "Users can insert own progress"
  ON user_video_progress FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Usuários podem atualizar seu próprio progresso
CREATE POLICY "Users can update own progress"
  ON user_video_progress FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- Usuários podem deletar seu próprio progresso
CREATE POLICY "Users can delete own progress"
  ON user_video_progress FOR DELETE
  USING (auth.uid() = user_id);

-- Admins podem ver todo o progresso
CREATE POLICY "Admins can view all progress"
  ON user_video_progress FOR SELECT
  USING (auth.jwt() ->> 'role' = 'admin');

-- -----------------------------------------------------
-- Políticas para: user_video_favorites
-- -----------------------------------------------------
CREATE POLICY "Users can view own favorites"
  ON user_video_favorites FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own favorites"
  ON user_video_favorites FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own favorites"
  ON user_video_favorites FOR DELETE
  USING (auth.uid() = user_id);

CREATE POLICY "Admins can view all favorites"
  ON user_video_favorites FOR SELECT
  USING (auth.jwt() ->> 'role' = 'admin');

-- -----------------------------------------------------
-- Políticas para: user_video_ratings
-- -----------------------------------------------------
CREATE POLICY "Users can view own ratings"
  ON user_video_ratings FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Everyone can view published ratings"
  ON user_video_ratings FOR SELECT
  USING (true);

CREATE POLICY "Users can insert own ratings"
  ON user_video_ratings FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own ratings"
  ON user_video_ratings FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own ratings"
  ON user_video_ratings FOR DELETE
  USING (auth.uid() = user_id);

-- =====================================================
-- 5. VIEWS ÚTEIS
-- =====================================================

-- -----------------------------------------------------
-- View: videos_with_details
-- Descrição: Vídeos com todas as informações relacionadas
-- -----------------------------------------------------
CREATE OR REPLACE VIEW videos_with_details AS
SELECT 
  v.id,
  v.title,
  v.subtitle,
  v.slug,
  v.description,
  v.duration_minutes,
  v.video_url,
  v.thumbnail_url,
  v.badge,
  v.is_new,
  v.is_featured,
  v.difficulty_level,
  v.view_count,
  v.average_rating,
  v.rating_count,
  v.is_published,
  v.published_at,
  v.created_at,
  v.updated_at,
  
  -- Category info
  c.id as category_id,
  c.name as category_name,
  c.slug as category_slug,
  c.icon_name as category_icon,
  
  -- Section info
  s.id as section_id,
  s.name as section_name,
  s.subtitle as section_subtitle,
  
  -- Instructor info
  i.id as instructor_id,
  i.full_name as instructor_name,
  i.professional_title as instructor_title,
  i.type as instructor_type,
  i.avatar_url as instructor_avatar,
  
  -- Concatenated instructor display (ex: "Com Enf. Maria Silva")
  CONCAT('Com ', i.professional_title, ' ', i.full_name) as instructor_display,
  
  -- Duration formatted (ex: "18min")
  CONCAT(v.duration_minutes, 'min') as duration_display
  
FROM videos v
LEFT JOIN categories c ON v.category_id = c.id
LEFT JOIN sections s ON v.section_id = s.id
LEFT JOIN instructors i ON v.instructor_id = i.id
WHERE v.is_active = true;

COMMENT ON VIEW videos_with_details IS 'View consolidada com todos os detalhes dos vídeos';

-- -----------------------------------------------------
-- View: category_video_counts
-- Descrição: Contagem de vídeos por categoria
-- -----------------------------------------------------
CREATE OR REPLACE VIEW category_video_counts AS
SELECT 
  c.id,
  c.name,
  c.slug,
  c.icon_name,
  c.display_order,
  COUNT(v.id) as video_count
FROM categories c
LEFT JOIN videos v ON c.id = v.category_id AND v.is_published = true AND v.is_active = true
WHERE c.is_active = true
GROUP BY c.id, c.name, c.slug, c.icon_name, c.display_order
ORDER BY c.display_order;

COMMENT ON VIEW category_video_counts IS 'Categorias com contagem de vídeos publicados';

-- -----------------------------------------------------
-- View: user_learning_stats
-- Descrição: Estatísticas de aprendizado por usuário
-- -----------------------------------------------------
CREATE OR REPLACE VIEW user_learning_stats AS
SELECT 
  user_id,
  COUNT(DISTINCT video_id) as total_videos_watched,
  COUNT(DISTINCT CASE WHEN watch_status = 'completed' THEN video_id END) as videos_completed,
  COUNT(DISTINCT CASE WHEN watch_status = 'in_progress' THEN video_id END) as videos_in_progress,
  SUM(CASE WHEN watch_status = 'completed' THEN 1 ELSE 0 END)::DECIMAL / 
    NULLIF(COUNT(DISTINCT video_id), 0) * 100 as completion_percentage,
  MAX(last_watched_at) as last_activity,
  MIN(started_at) as first_activity
FROM user_video_progress
GROUP BY user_id;

COMMENT ON VIEW user_learning_stats IS 'Estatísticas de progresso de aprendizado por usuário';

-- =====================================================
-- 6. FUNÇÕES ÚTEIS
-- =====================================================

-- -----------------------------------------------------
-- Função: search_videos
-- Descrição: Busca full-text em vídeos
-- -----------------------------------------------------
CREATE OR REPLACE FUNCTION search_videos(search_query TEXT)
RETURNS TABLE (
  id UUID,
  title VARCHAR,
  subtitle TEXT,
  slug VARCHAR,
  category_name VARCHAR,
  instructor_display TEXT,
  duration_display TEXT,
  rank REAL
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    vd.id,
    vd.title,
    vd.subtitle,
    vd.slug,
    vd.category_name,
    vd.instructor_display,
    vd.duration_display,
    ts_rank(v.search_vector, plainto_tsquery('portuguese', search_query)) as rank
  FROM videos v
  JOIN videos_with_details vd ON v.id = vd.id
  WHERE v.search_vector @@ plainto_tsquery('portuguese', search_query)
    AND v.is_published = true
    AND v.is_active = true
  ORDER BY rank DESC, vd.view_count DESC
  LIMIT 50;
END;
$$ LANGUAGE plpgsql STABLE;

COMMENT ON FUNCTION search_videos IS 'Busca full-text em vídeos com ranking de relevância';

-- -----------------------------------------------------
-- Função: increment_video_view
-- Descrição: Incrementa contador de visualizações
-- -----------------------------------------------------
CREATE OR REPLACE FUNCTION increment_video_view(video_uuid UUID)
RETURNS VOID AS $$
BEGIN
  UPDATE videos
  SET view_count = view_count + 1
  WHERE id = video_uuid;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION increment_video_view IS 'Incrementa contador de visualizações de um vídeo';

-- -----------------------------------------------------
-- Função: get_recommended_videos
-- Descrição: Recomendações personalizadas baseadas no histórico
-- -----------------------------------------------------
CREATE OR REPLACE FUNCTION get_recommended_videos(for_user_id UUID, limit_count INTEGER DEFAULT 10)
RETURNS TABLE (
  id UUID,
  title VARCHAR,
  subtitle TEXT,
  slug VARCHAR,
  category_name VARCHAR,
  instructor_display TEXT,
  duration_display TEXT,
  relevance_score DECIMAL
) AS $$
BEGIN
  RETURN QUERY
  WITH user_categories AS (
    -- Categorias mais assistidas pelo usuário
    SELECT v.category_id, COUNT(*) as watch_count
    FROM user_video_progress uvp
    JOIN videos v ON uvp.video_id = v.id
    WHERE uvp.user_id = for_user_id
    GROUP BY v.category_id
    ORDER BY watch_count DESC
    LIMIT 3
  ),
  user_watched AS (
    -- Vídeos já assistidos pelo usuário
    SELECT video_id
    FROM user_video_progress
    WHERE user_id = for_user_id
  )
  SELECT 
    vd.id,
    vd.title,
    vd.subtitle,
    vd.slug,
    vd.category_name,
    vd.instructor_display,
    vd.duration_display,
    (
      CASE 
        WHEN v.category_id IN (SELECT category_id FROM user_categories) THEN 2.0
        ELSE 1.0
      END *
      CASE WHEN v.is_featured THEN 1.5 ELSE 1.0 END *
      CASE WHEN v.badge = 'essential' THEN 1.3 ELSE 1.0 END *
      (1 + (v.average_rating / 5.0)) *
      (1 + LOG(1 + v.view_count) / 10)
    )::DECIMAL(10,2) as relevance_score
  FROM videos v
  JOIN videos_with_details vd ON v.id = vd.id
  WHERE v.is_published = true
    AND v.is_active = true
    AND v.id NOT IN (SELECT video_id FROM user_watched)
  ORDER BY relevance_score DESC
  LIMIT limit_count;
END;
$$ LANGUAGE plpgsql STABLE;

COMMENT ON FUNCTION get_recommended_videos IS 'Retorna vídeos recomendados baseados no perfil do usuário';

-- =====================================================
-- 7. DADOS INICIAIS (SEED)
-- =====================================================

-- Inserir categorias
INSERT INTO categories (name, slug, icon_name, display_order) VALUES
  ('Higiene', 'higiene', 'Droplet', 1),
  ('Alimentação', 'alimentacao', 'Activity', 2),
  ('Mobilidade', 'mobilidade', 'Move', 3),
  ('Dor', 'dor', 'Heart', 4),
  ('Dispositivos', 'dispositivos', 'Stethoscope', 5),
  ('Fim de Vida', 'fim-de-vida', 'Sparkles', 6),
  ('Respiração', 'respiracao', 'Wind', 7),
  ('Sintomas', 'sintomas', 'Activity', 8);

-- Inserir seções
INSERT INTO sections (name, slug, subtitle, display_order) VALUES
  ('Cuidados Básicos com o Paciente', 'cuidados-basicos', 'Procedimentos essenciais do dia a dia', 1),
  ('Mobilidade e Reabilitação', 'mobilidade-reabilitacao', 'Exercícios e suporte à movimentação', 2),
  ('Controle de Sintomas', 'controle-sintomas', 'Manejo de dor e desconforto', 3),
  ('Suporte ao Fim de Vida', 'suporte-fim-vida', 'Cuidados no final da jornada', 4),
  ('Cuidados com Dispositivos', 'cuidados-dispositivos', 'Manutenção e procedimentos', 5);

-- =====================================================
-- 8. GRANTS E PERMISSÕES
-- =====================================================

-- Conceder permissões de leitura para usuários autenticados
GRANT SELECT ON categories TO authenticated;
GRANT SELECT ON sections TO authenticated;
GRANT SELECT ON instructors TO authenticated;
GRANT SELECT ON videos TO authenticated;
GRANT SELECT ON video_tags TO authenticated;
GRANT SELECT ON videos_tags TO authenticated;

-- Conceder todas as permissões nas tabelas de usuário
GRANT ALL ON user_video_progress TO authenticated;
GRANT ALL ON user_video_favorites TO authenticated;
GRANT ALL ON user_video_ratings TO authenticated;

-- Conceder acesso às views
GRANT SELECT ON videos_with_details TO authenticated;
GRANT SELECT ON category_video_counts TO authenticated;
GRANT SELECT ON user_learning_stats TO authenticated;

-- Conceder execução das funções
GRANT EXECUTE ON FUNCTION search_videos TO authenticated;
GRANT EXECUTE ON FUNCTION increment_video_view TO authenticated;
GRANT EXECUTE ON FUNCTION get_recommended_videos TO authenticated;

-- =====================================================
-- FIM DO SCHEMA
-- =====================================================
