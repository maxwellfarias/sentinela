# 📱 Guia de Conversão de Telas React para Flutter
REALIZAR FIELMENTE A CONVERSÃO DE TELAS DO REACT PARA FLUTTER.

**Path**: `/lib/ui/{nome_tela}/widget/{nome_tela}.dart`

**⚠️ ORGANIZAÇÃO DE COMPONENTES OBRIGATÓRIA:**

Para evitar que a screen principal fique muito grande, **DEVE-SE** criar uma pasta `componentes` dentro da estrutura:

```
/lib/ui/{nome_tela}/widget/
├── {nome_tela}.dart                    # ← Screen principal (LIMPA E ENXUTA)
└── componentes/                        # ← Pasta obrigatória para componentes
    ├── {nome_tela}_card.dart          # ← Card/item da lista
    ├── {nome_tela}_form_dialog.dart   # ← Modal de criação/edição
    ├── {nome_tela}_filter_bar.dart    # ← Barra de filtros
    ├── {nome_tela}_stats_panel.dart   # ← Painel de estatísticas
    └── {nome_tela}_empty_state.dart   # ← Estado vazio customizado

```

**🚫 NÃO CRIAR componentes muito pequenos** (menos de 30 linhas) - prefira manter na screen principal.

**✅ CRIAR componentes quando tiver:**

- Cards complexos com múltiplas interações
- Formulários de criação/edição
- Modais ou dialogs elaborados
- Barras de filtro ou busca
- Painéis de estatísticas
- Estados vazios customizados
- Seções com lógica própria

### 🎨 **MAPEAMENTO DE ESTILOS OBRIGATÓRIO**

### 📝 **Tipografia (React Tailwind → Flutter CustomTextTheme)**

**IMPORTANTE**: Todo `Theme.of(context).textTheme` DEVE ser substituído por `context.customTextTheme`:

| React Tailwind Class | Tamanho | Peso | Flutter Equivalent (OBRIGATÓRIO) |
| --- | --- | --- | --- |
| `text-4xl font-bold` | 36px | 700 | `context.customTextTheme.text4xlBold` |
| `text-3xl font-bold` | 30px | 700 | `context.customTextTheme.text3xlBold` |
| `text-2xl font-bold` | 24px | 700 | `context.customTextTheme.text2xlBold` |
| `text-xl font-semibold` | 20px | 600 | `context.customTextTheme.textXlSemibold` |
| `text-xl font-medium` | 20px | 500 | `context.customTextTheme.textXlMedium` |
| `text-lg font-semibold` | 18px | 600 | `context.customTextTheme.textLgSemibold` |
| `text-lg font-medium` | 18px | 500 | `context.customTextTheme.textLgMedium` |
| `text-base font-medium` | 16px | 500 | `context.customTextTheme.textBaseMedium` |
| `text-base` | 16px | 400 | `context.customTextTheme.textBase` |
| `text-sm font-semibold` | 14px | 600 | `context.customTextTheme.textSmSemibold` |
| `text-sm font-medium` | 14px | 500 | `context.customTextTheme.textSmMedium` |
| `text-sm` | 14px | 400 | `context.customTextTheme.textSm` |
| `text-xs font-medium` | 12px | 500 | `context.customTextTheme.textXsMedium` |
| `text-xs` | 12px | 400 | `context.customTextTheme.textXs` |

### 🎨 **Cores (React CSS → Flutter NewAppColorTheme)**

**IMPORTANTE**: Todo `Colors.*`, `Theme.of(context).colorScheme.*` DEVE ser substituído por `context.customColorTheme`:

| React CSS Variable | Descrição | Flutter Equivalent (OBRIGATÓRIO) |
| --- | --- | --- |
| `--background` | Fundo principal | `context.customColorTheme.background` |
| `--foreground` | Texto principal | `context.customColorTheme.foreground` |
| `--primary` | Cor primária | `context.customColorTheme.primary` |
| `--primary-foreground` | Texto sobre primário | `context.customColorTheme.primaryForeground` |
| `--primary-light` | Primário claro | `context.customColorTheme.primaryLight` |
| `--primary-dark` | Primário escuro | `context.customColorTheme.primaryShade` |
| `--secondary` | Cor secundária | `context.customColorTheme.secondary` |
| `--secondary-foreground` | Texto sobre secundário | `context.customColorTheme.secondaryForeground` |
| `--success` | Verde de sucesso | `context.customColorTheme.success` |
| `--success-foreground` | Texto sobre sucesso | `context.customColorTheme.successForeground` |
| `--warning` | Laranja de aviso | `context.customColorTheme.warning` |
| `--warning-foreground` | Texto sobre aviso | `context.customColorTheme.warningForeground` |
| `--destructive` | Vermelho de erro | `context.customColorTheme.destructive` |
| `--destructive-foreground` | Texto sobre erro | `context.customColorTheme.destructiveForeground` |
| `--card` | Fundo de cards | `context.customColorTheme.card` |
| `--card-foreground` | Texto em cards | `context.customColorTheme.cardForeground` |
| `--muted` | Fundo neutro | `context.customColorTheme.muted` |
| `--muted-foreground` | Texto secundário | `context.customColorTheme.mutedForeground` |
| `--accent` | Cor de destaque | `context.customColorTheme.accent` |
| `--accent-foreground` | Texto sobre destaque | `context.customColorTheme.accentForeground` |
| `--border` | Bordas | `context.customColorTheme.border` |
| `--input` | Fundo de inputs | `context.customColorTheme.input` |
| `--ring` | Foco/seleção | `context.customColorTheme.ring` |

### 🚫 **CONVERSÕES PROIBIDAS**

❌ **NÃO usar**:

- `Theme.of(context).textTheme.*`
- `Colors.red`, `Colors.blue`, `Colors.green`, etc.
- `context.colorScheme.*`
- Cores hardcoded como `Color(0xFF...)`

✅ **SEMPRE usar**:

- `context.customTextTheme.*`
- `context.customColorTheme.*`

### 📦 **Import Obrigatório**

```dart
import 'package:mastering_tests/ui/core/extensions/build_context_extension.dart';

```

### 🎯 **Exemplos de Conversão Obrigatória**

```dart
// ❌ ERRADO - Não usar
Text(
  'Título',
  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
    fontWeight: FontWeight.bold,
    color: Colors.blue,
  ),
)

// ✅ CORRETO - Usar sempre
Text(
  'Título',
  style: context.customTextTheme.text2xlBold.copyWith(
    color: context.customColorTheme.primary,
  ),
)

// ❌ ERRADO - Card com cores hardcoded
Card(
  color: Colors.white,
  child: Text('Conteúdo', style: TextStyle(color: Colors.black)),
)

// ✅ CORRETO - Card com tema customizado
Card(
  color: context.customColorTheme.card,
  child: Text(
    'Conteúdo',
    style: context.customTextTheme.textBase.copyWith(
      color: context.customColorTheme.cardForeground,
    ),
  ),
)

```

### ✅ **Conversão de Estilos**

- [ ]  **Tipografia**: Mapear classes CSS para CustomTextTheme
- [ ]  **Cores**: Converter variáveis CSS para NewAppColorTheme
- [ ]  **Layout Responsivo**: Adaptar para LayoutBuilder e MediaQuery
- [ ]  **Animações**: Implementar transições e micro-interações
- [ ]  **Espaçamentos**: Converter padding/margin Tailwind para EdgeInsets
- [ ]  **Sombras e Elevação**: Mapear box-shadow para elevation


### IMPORTANTE! Ao final da conversão, não crie arquivos de Redme ou documentação. Apenas a tela convertida com os componentes organizados conforme o guia.