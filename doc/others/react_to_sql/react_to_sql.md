## 📊 Análise Completa e Geração de Schema SQL para Componente React

**ARQUIVO ALVO**: `lovable/src/pages/{CAMINHO_DO_ARQUIVO}.tsx`

**OBJETIVO**: Realizar mapeamento completo de dados do componente React especificado e todos os seus componentes importados, seguido da geração de schemas SQL otimizados para Supabase.

---

### ✅ FASE 1: MAPEAMENTO DE DADOS (OBRIGATÓRIO)

Analise o arquivo TSX alvo e **TODOS os componentes/hooks importados** para identificar:

#### 1. **📋 Estruturas de Dados**
- [ ] Schemas Zod/Yup/outros validadores
- [ ] Interfaces TypeScript e Types
- [ ] Props de componentes
- [ ] Estados (useState, useReducer)
- [ ] Dados de contextos (useContext)

#### 2. **🔗 Dependências e Importações**
- [ ] Componentes UI importados (`@/components/*`)
- [ ] Hooks customizados (`use*`)
- [ ] Serviços/APIs (`@/services/*`, `@/api/*`)
- [ ] Integrações Supabase existentes (`@/integrations/supabase/*`)
- [ ] Stores/Context Providers (Zustand, Redux, Context API)

#### 3. **📦 Enums e Constantes**
- [ ] Arrays de opções (select, radio, checkbox)
- [ ] Mapeamentos de valores
- [ ] Configurações estáticas
- [ ] Valores de validação (min, max, patterns)

#### 4. **🔄 Relacionamentos**
- [ ] Referências a usuários/autenticação
- [ ] Relacionamentos com outras entidades
- [ ] Dados hierárquicos (parent/child)
- [ ] Tabelas de lookup/referência

#### 5. **🎭 Lógica de Negócio**
- [ ] Regras de validação
- [ ] Cálculos derivados
- [ ] Filtros e transformações
- [ ] Status e estados do sistema

---

### ✅ FASE 2: GERAÇÃO DE SQL (OBRIGATÓRIO)

Com base no mapeamento, gere **schemas SQL production-ready para Supabase** seguindo estas regras:

### IMPORTANTE: 1. A criação das tabelas deve seguir o padrão 3NF (Terceira Forma Normal).

#### 🎯 ESTRUTURA OBRIGATÓRIA (em ordem):

```sql
-- =====================================================
-- 1. ENUMS (se aplicável)
-- =====================================================

-- =====================================================
-- 2. TABELAS PRINCIPAIS
-- =====================================================

-- =====================================================
-- 3. TABELAS DE RELACIONAMENTO (se aplicável)
-- =====================================================

-- =====================================================
-- 4. ROW LEVEL SECURITY (RLS)
-- =====================================================
