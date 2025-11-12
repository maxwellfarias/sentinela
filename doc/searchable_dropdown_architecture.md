# SearchableDropdown - Arquitetura e Implementação Detalhada

## 📋 Sumário

1. [Visão Geral](#visão-geral)
2. [Componentes Flutter Utilizados](#componentes-flutter-utilizados)
3. [Arquitetura do Widget](#arquitetura-do-widget)
4. [Fluxo de Funcionamento](#fluxo-de-funcionamento)
5. [Problemas Resolvidos](#problemas-resolvidos)
6. [Diagramas](#diagramas)

---

## Visão Geral

O `SearchableDropdown` é um componente customizado que combina:
- Um campo de seleção (dropdown)
- Busca em tempo real
- Validação integrada com formulários Flutter
- Interface responsiva e acessível

**Localização**: `lib/ui/core/componentes_reutilizaveis/searchable_dropdown.dart`

---

## Componentes Flutter Utilizados

### 1. **LayerLink** 🔗

```dart
final LayerLink _layerLink = LayerLink();
```

#### O que é?
`LayerLink` é um objeto que cria uma "âncora" de posicionamento entre dois widgets na árvore de widgets do Flutter.

#### Como funciona?
- Funciona como um "pino" que conecta dois widgets
- Um widget usa `CompositedTransformTarget` (o alvo)
- Outro widget usa `CompositedTransformFollower` (o seguidor)
- O seguidor sempre sabe onde o alvo está, mesmo após scroll ou animações

#### Por que usamos?
No `SearchableDropdown`, o `LayerLink` conecta:
- **Alvo**: O botão do dropdown (campo de seleção visível)
- **Seguidor**: O overlay com a lista de itens (que aparece flutuando)

Isso garante que o overlay sempre apareça na posição correta, logo abaixo do campo, mesmo que a tela role.

#### Código no Widget:
```dart
// No build() - Define o alvo
CompositedTransformTarget(
  link: _layerLink,  // ← "Pino" fixado aqui
  child: FormField(...),
)
```

---

### 2. **OverlayEntry** 🎭

```dart
OverlayEntry? _overlayEntry;
```

#### O que é?
`OverlayEntry` é uma "camada flutuante" que pode ser posicionada sobre toda a interface, independente da hierarquia de widgets.

#### Como funciona?
- Pense nele como uma "folha de papel transparente" colocada sobre a tela
- Pode conter qualquer widget
- Flutua acima de todo o conteúdo existente
- Não afeta o layout dos outros widgets

#### Por que usamos?
No `SearchableDropdown`, o overlay é usado para:
- Mostrar a lista de itens **sobre** o conteúdo da página
- Não deslocar outros elementos da interface
- Permitir que apareça sobre dialogs, cards, etc.

#### Ciclo de Vida:
```dart
// 1. Criar
_overlayEntry = _createOverlayEntry();

// 2. Inserir no Overlay da tela
Overlay.of(context).insert(_overlayEntry!);

// 3. Atualizar (quando a lista muda)
_overlayEntry?.markNeedsBuild();

// 4. Remover
_overlayEntry?.remove();
_overlayEntry = null;
```

#### Código de Criação:
```dart
OverlayEntry _createOverlayEntry() {
  return OverlayEntry(
    builder: (overlayContext) => /* Widget que será exibido */
  );
}
```

---

### 3. **CompositedTransformTarget** 🎯

```dart
CompositedTransformTarget(
  link: _layerLink,
  child: FormField(...),
)
```

#### O que é?
É o widget **alvo** que marca a posição de referência para o `CompositedTransformFollower`.

#### Como funciona?
- Registra sua posição na tela usando o `LayerLink`
- Não altera o comportamento visual do seu filho
- Atualiza automaticamente a posição quando o widget se move

#### Por que usamos?
Marca onde o campo de seleção está localizado, permitindo que o overlay apareça exatamente abaixo dele.

---

### 4. **Positioned** 📍

```dart
Positioned(
  left: offset.dx,
  top: offset.dy + size.height + 4,
  width: size.width,
  child: /* Dropdown menu */
)
```

#### O que é?
Widget que posiciona um filho dentro de um `Stack` usando coordenadas absolutas.

#### Como funciona?
- Usa coordenadas x,y da tela
- Define tamanho (width, height) opcional
- Funciona apenas dentro de um `Stack`

#### Por que usamos?
Posiciona o overlay exatamente onde queremos na tela:
- **left**: Alinha com a borda esquerda do campo
- **top**: Posiciona logo abaixo do campo (altura do campo + 4px de espaçamento)
- **width**: Mesma largura do campo

#### Cálculo da Posição:
```dart
final RenderBox renderBox = context.findRenderObject() as RenderBox;
final size = renderBox.size;  // Tamanho do campo
final offset = renderBox.localToGlobal(Offset.zero);  // Posição na tela

// offset.dx = posição X
// offset.dy = posição Y
// size.height = altura do campo
```

---

### 5. **ValueNotifier** 📢

```dart
final ValueNotifier<T?> controller;
```

#### O que é?
Um objeto que armazena um valor e notifica ouvintes quando o valor muda.

#### Como funciona?
```dart
// 1. Criar
final controller = ValueNotifier<String?>(null);

// 2. Escutar mudanças
controller.addListener(() {
  print('Valor mudou: ${controller.value}');
});

// 3. Mudar o valor (dispara notificação)
controller.value = "Novo valor";

// 4. Usar com ValueListenableBuilder
ValueListenableBuilder<String?>(
  valueListenable: controller,
  builder: (context, value, child) {
    return Text(value ?? 'Nenhum');
  },
)
```

#### Por que usamos?
- Gerencia o item selecionado
- Sincroniza o estado entre o dropdown e o FormField
- Permite que o widget pai observe mudanças

---

### 6. **FormField** 📝

```dart
FormField<T>(
  initialValue: selectedValue,
  validator: (_) => widget.validator?.call(widget.controller.value),
  autovalidateMode: AutovalidateMode.onUserInteraction,
  builder: (formFieldState) { ... },
)
```

#### O que é?
Widget que integra campos customizados ao sistema de formulários do Flutter.

#### Como funciona?
- Gerencia estado de validação
- Exibe mensagens de erro
- Integra com `Form` e `Form.validate()`

#### Métodos Importantes:
```dart
// Validar o campo
formFieldState.validate();

// Mudar o valor (dispara validação)
formFieldState.didChange(newValue);

// Verificar se tem erro
if (formFieldState.hasError) {
  print(formFieldState.errorText);
}
```

#### Por que usamos?
Permite que o `SearchableDropdown` funcione como qualquer campo de formulário Flutter:
```dart
Form(
  key: _formKey,
  child: Column(
    children: [
      SearchableDropdown(...),  // ← Validado junto com outros campos
      TextFormField(...),
    ],
  ),
)

// Validar todo o formulário
if (_formKey.currentState?.validate() == true) {
  // Todos os campos são válidos
}
```

---

### 7. **GestureDetector** 👆

```dart
GestureDetector(
  behavior: HitTestBehavior.translucent,
  onTap: () { ... },
  child: ...
)
```

#### O que é?
Widget que detecta gestos (toques, arrastar, pinça, etc).

#### HitTestBehavior explicado:
- **`opaque`**: Captura todos os toques, mesmo em áreas transparentes
- **`translucent`**: Captura toques mas permite que passem através
- **`deferToChild`**: Só captura toques em áreas com conteúdo visível

#### Por que usamos?
Usamos **dois** GestureDetector:

1. **Externo** (translucent): Detecta cliques **fora** do dropdown para fechar
```dart
GestureDetector(
  behavior: HitTestBehavior.translucent,
  onTap: () => _closeDropdown(),  // Fecha ao clicar fora
  child: Stack(...)
)
```

2. **Interno** (opaque): Previne que cliques **dentro** fechem o dropdown
```dart
GestureDetector(
  behavior: HitTestBehavior.opaque,
  onTap: () {},  // Não faz nada, só bloqueia propagação
  child: Material(...)  // Dropdown menu
)
```

---

### 8. **FocusNode** 🔍

```dart
final FocusNode _focusNode = FocusNode();
```

#### O que é?
Objeto que gerencia o foco do teclado em um widget.

#### Como funciona?
```dart
// 1. Dar foco
_focusNode.requestFocus();

// 2. Remover foco
_focusNode.unfocus();

// 3. Verificar se tem foco
if (_focusNode.hasFocus) { ... }

// 4. Escutar mudanças de foco
_focusNode.addListener(() {
  print('Tem foco: ${_focusNode.hasFocus}');
});
```

#### Por que usamos?
- Dar foco automático ao campo de busca quando o dropdown abre
- Detectar quando o usuário clica fora (perde o foco)
- Fechar o dropdown quando o foco é perdido

---

## Arquitetura do Widget

### Estrutura Visual

```
┌─────────────────────────────────────┐
│  CompositedTransformTarget         │  ← Marca a posição
│  ┌───────────────────────────────┐ │
│  │  ValueListenableBuilder       │ │  ← Observa mudanças no valor
│  │  ┌─────────────────────────┐  │ │
│  │  │  FormField              │  │ │  ← Validação
│  │  │  ┌───────────────────┐  │  │ │
│  │  │  │  InkWell          │  │  │ │  ← Detecta clique
│  │  │  │  ┌─────────────┐  │  │  │ │
│  │  │  │  │  Container  │  │  │  │ │  ← Aparência
│  │  │  │  │  "Turma *"  │  │  │  │ │
│  │  │  │  └─────────────┘  │  │  │ │
│  │  │  └───────────────────┘  │  │ │
│  │  └─────────────────────────┘  │ │
│  └───────────────────────────────┘ │
└─────────────────────────────────────┘

         │ (quando clicado)
         ▼

┌─────────────────────────────────────┐
│  OverlayEntry (flutua sobre tudo)  │
│  ┌───────────────────────────────┐ │
│  │  GestureDetector (externo)    │ │  ← Detecta clique fora
│  │  ┌─────────────────────────┐  │ │
│  │  │  Stack                  │  │ │
│  │  │  ┌───────────────────┐  │  │ │
│  │  │  │ Positioned.fill   │  │  │ │  ← Área transparente
│  │  │  └───────────────────┘  │  │ │
│  │  │  ┌───────────────────┐  │  │ │
│  │  │  │ Positioned        │  │  │ │  ← Posiciona dropdown
│  │  │  │ ┌───────────────┐ │  │  │ │
│  │  │  │ │ GestureDetect.│ │  │  │ │  ← Bloqueia clique fora
│  │  │  │ │ ┌───────────┐ │ │  │  │ │
│  │  │  │ │ │ Material  │ │ │  │  │ │
│  │  │  │ │ │ ┌───────┐ │ │ │  │  │ │
│  │  │  │ │ │ │Search │ │ │ │  │  │ │  ← Campo de busca
│  │  │  │ │ │ └───────┘ │ │ │  │  │ │
│  │  │  │ │ │ ┌───────┐ │ │ │  │  │ │
│  │  │  │ │ │ │ListView│ │ │ │  │  │ │  ← Lista de itens
│  │  │  │ │ │ │       │ │ │ │  │  │ │
│  │  │  │ │ │ │ Item1 │ │ │ │  │  │ │
│  │  │  │ │ │ │ Item2 │ │ │ │  │  │ │
│  │  │  │ │ │ │ Item3 │ │ │ │  │  │ │
│  │  │  │ │ │ └───────┘ │ │ │  │  │ │
│  │  │  │ │ └───────────┘ │ │  │  │ │
│  │  │  │ └───────────────┘ │  │  │ │
│  │  │  └───────────────────┘  │  │ │
│  │  └─────────────────────────┘  │ │
│  └───────────────────────────────┘ │
└─────────────────────────────────────┘
```

---

## Fluxo de Funcionamento

### 1. Inicialização

```dart
@override
void initState() {
  super.initState();
  _filteredItems = widget.items;  // Copia todos os itens
  widget.controller.addListener(_onControllerChanged);  // Escuta mudanças
  _focusNode.addListener(_onFocusChanged);  // Escuta mudanças de foco
}
```

**O que acontece:**
1. Lista filtrada começa com todos os itens
2. Registra ouvinte para quando o valor selecionado mudar
3. Registra ouvinte para quando o foco mudar

---

### 2. Abertura do Dropdown

```
Usuário clica no campo
         ↓
    _toggleDropdown()
         ↓
    _openDropdown()
         ↓
  _createOverlayEntry()  ← Cria o overlay com a lista
         ↓
Overlay.of(context).insert(_overlayEntry!)  ← Insere na tela
         ↓
setState(() => _isOpen = true)  ← Marca como aberto
         ↓
_focusNode.requestFocus()  ← Foca no campo de busca
```

**Código:**
```dart
void _openDropdown() {
  _overlayEntry = _createOverlayEntry();  // Cria
  Overlay.of(context).insert(_overlayEntry!);  // Mostra
  setState(() => _isOpen = true);  // Atualiza estado
  _focusNode.requestFocus();  // Foca na busca
}
```

---

### 3. Busca/Filtragem

```
Usuário digita no campo de busca
         ↓
TextField.onChanged(_filterItems)
         ↓
    _filterItems(query)
         ↓
Filtra items por query.toLowerCase()
         ↓
setState(() => _filteredItems = ...)  ← Atualiza lista
         ↓
_overlayEntry?.markNeedsBuild()  ← Reconstrói overlay
         ↓
ListView.builder mostra itens filtrados
```

**Código:**
```dart
void _filterItems(String query) {
  setState(() {
    if (query.isEmpty) {
      _filteredItems = widget.items;  // Mostra todos
    } else {
      final lowerQuery = query.toLowerCase();
      _filteredItems = widget.items.where((item) {
        return widget.itemAsString(item)
          .toLowerCase()
          .contains(lowerQuery);
      }).toList();
    }
  });
  _overlayEntry?.markNeedsBuild();  // Atualiza overlay
}
```

---

### 4. Seleção de Item

```
Usuário clica em um item
         ↓
InkWell.onTap()
         ↓
_focusNode.unfocus()  ← Remove foco do campo de busca
         ↓
    _selectItem(item)
         ↓
widget.controller.value = item  ← Atualiza valor (dispara notificação)
         ↓
widget.onChanged?.call(item)  ← Callback opcional
         ↓
    _closeDropdown()
         ↓
_overlayEntry?.remove()  ← Remove overlay da tela
         ↓
setState(() {
  _isOpen = false;
  _searchController.clear();
  _filteredItems = widget.items;
})
```

**Fluxo de Atualização após Seleção:**
```
controller.value mudou
         ↓
ValueListenableBuilder detecta mudança
         ↓
Reconstrói FormField com novo valor
         ↓
WidgetsBinding.addPostFrameCallback
         ↓
formFieldState.didChange(novo valor)
         ↓
FormField executa validator
         ↓
Erro desaparece se valor válido
```

---

### 5. Fechamento do Dropdown

**Três formas de fechar:**

#### A) Clique em um item
```dart
_selectItem(item) → _closeDropdown()
```

#### B) Clique fora do dropdown
```dart
GestureDetector(externo).onTap → _closeDropdown()
```

#### C) Perda de foco
```dart
_focusNode perde foco
         ↓
_onFocusChanged() detecta
         ↓
Future.delayed(150ms)  ← Aguarda onTap processar
         ↓
_closeDropdown()
```

**Por que o delay?**
```dart
void _onFocusChanged() {
  if (!_focusNode.hasFocus && _isOpen) {
    // Delay crítico! Sem ele:
    // 1. Usuário clica no item
    // 2. Campo de busca perde foco
    // 3. _closeDropdown() é chamado IMEDIATAMENTE
    // 4. Overlay é removido ANTES do onTap processar
    // 5. Item não é selecionado ❌

    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted && _isOpen) {
        _closeDropdown();
      }
    });
  }
}
```

---

## Problemas Resolvidos

### Problema 1: Item não era selecionado ao clicar

**Causa:**
```dart
// Antes:
void _onFocusChanged() {
  if (!_focusNode.hasFocus && _isOpen) {
    _closeDropdown();  // Chamado imediatamente!
  }
}
```

**Sequência do problema:**
1. Usuário clica no item
2. Campo de busca perde foco → dispara `_onFocusChanged()`
3. `_closeDropdown()` é chamado e remove o overlay
4. `InkWell.onTap()` tenta executar mas o widget foi destruído
5. `_selectItem()` nunca é chamado

**Solução:**
```dart
// Depois:
void _onFocusChanged() {
  if (!_focusNode.hasFocus && _isOpen) {
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted && _isOpen) {
        _closeDropdown();
      }
    });
  }
}
```

Agora:
1. Usuário clica no item
2. Campo de busca perde foco → dispara `_onFocusChanged()`
3. `Future.delayed()` agenda fechamento para daqui 150ms
4. `InkWell.onTap()` executa **primeiro** → `_selectItem()` é chamado
5. Overlay fecha depois que seleção foi processada ✅

---

### Problema 2: Cliques dentro do dropdown o fechavam

**Causa:**
```dart
// Antes:
GestureDetector(
  onTap: () => _closeDropdown(),  // Capturava TODOS os toques
  child: Positioned(...),  // Dropdown ficava aqui dentro
)
```

Qualquer clique, mesmo em itens da lista, fechava o dropdown.

**Solução:**
```dart
// Depois:
GestureDetector(
  behavior: HitTestBehavior.translucent,
  onTap: () => _closeDropdown(),  // Fecha ao clicar fora
  child: Stack(
    children: [
      Positioned.fill(
        child: Container(color: Colors.transparent),  // Área de fundo
      ),
      Positioned(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {},  // BLOQUEIA propagação do toque
          child: Material(...),  // Dropdown
        ),
      ),
    ],
  ),
)
```

**Como funciona:**
```
Clique em item da lista
         ↓
GestureDetector interno (opaque) captura
         ↓
onTap: () {} não faz nada
         ↓
Toque NÃO se propaga para GestureDetector externo
         ↓
InkWell.onTap() do item é executado
         ↓
Item selecionado ✅

Clique fora do dropdown
         ↓
GestureDetector interno NÃO captura
         ↓
Toque se propaga para GestureDetector externo
         ↓
onTap: () => _closeDropdown()
         ↓
Dropdown fecha ✅
```

---

### Problema 3: InkWell não tinha feedback visual

**Causa:**
```dart
// Antes:
ListView.builder(
  itemBuilder: (context, index) {
    return InkWell(  // Sem Material pai
      onTap: () => _selectItem(item),
      child: Container(...),
    );
  },
)
```

`InkWell` precisa de um widget `Material` acima dele para o efeito ripple funcionar.

**Solução:**
```dart
// Depois:
ListView.builder(
  itemBuilder: (context, index) {
    return Material(  // ← Adicionado!
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          _focusNode.unfocus();  // Remove foco primeiro
          _selectItem(item);
        },
        child: Container(...),
      ),
    );
  },
)
```

Agora o InkWell tem feedback visual (ripple effect) ✅

---

## Diagramas

### Diagrama de Estados

```
┌─────────────┐
│   FECHADO   │ (_isOpen = false)
└──────┬──────┘
       │
       │ Usuário clica no campo
       │ _toggleDropdown()
       ▼
┌─────────────┐
│    ABRINDO  │
└──────┬──────┘
       │
       │ _createOverlayEntry()
       │ Overlay.of(context).insert()
       │ _focusNode.requestFocus()
       ▼
┌─────────────┐
│    ABERTO   │ (_isOpen = true)
└──────┬──────┘
       │
       ├─── Usuário digita ──→ _filterItems() ──→ Reconstrói lista
       │
       ├─── Usuário clica item ──→ _selectItem() ──┐
       │                                            │
       ├─── Usuário clica fora ────────────────────┤
       │                                            │
       └─── Perde foco (150ms delay) ──────────────┤
                                                    ▼
                                            ┌─────────────┐
                                            │  FECHANDO   │
                                            └──────┬──────┘
                                                   │
                                                   │ _closeDropdown()
                                                   │ _overlayEntry?.remove()
                                                   ▼
                                            ┌─────────────┐
                                            │   FECHADO   │
                                            └─────────────┘
```

---

### Diagrama de Comunicação

```
┌──────────────────┐
│  Widget Pai      │
│  (Form)          │
└────────┬─────────┘
         │
         │ Passa ValueNotifier<T?>
         │ Escuta mudanças via addListener()
         ▼
┌──────────────────┐
│ SearchableDropdown│
└────────┬─────────┘
         │
         ├──→ ValueNotifier ←──┐
         │         ↕            │
         │    Sincroniza        │
         │         ↕            │
         └──→ FormField ────────┘
                  ↕
            Valida valor
                  ↕
         ┌────────────────┐
         │  Mostra erro   │
         │  ou sucesso    │
         └────────────────┘
```

---

### Diagrama de Posicionamento

```
┌─────────────────────────────────────────────────┐
│                                                 │
│  Página/Tela                                    │
│                                                 │
│  ┌───────────────────────────────────────────┐ │
│  │ Form                                      │ │
│  │                                           │ │
│  │  ┌─────────────────────────────────────┐ │ │
│  │  │ SearchableDropdown                  │ │ │ ← CompositedTransformTarget
│  │  │ ┌─────────────────────────────────┐ │ │ │   (marca posição com LayerLink)
│  │  │ │ "Selecione Turma"               │ │ │ │
│  │  │ │              🔽                  │ │ │ │
│  │  │ └─────────────────────────────────┘ │ │ │
│  │  └─────────────────────────────────────┘ │ │
│  │                                           │ │
│  │  ┌─────────────────────────────────────┐ │ │
│  │  │ Outro campo...                      │ │ │
│  │  └─────────────────────────────────────┘ │ │
│  └───────────────────────────────────────────┘ │
└─────────────────────────────────────────────────┘

Quando abre:

┌─────────────────────────────────────────────────┐
│  Overlay (camada flutuante sobre toda a tela)   │
│                                                 │
│  ┌───────────────────────────────────────────┐ │
│  │ GestureDetector (área transparente)       │ │
│  │                                           │ │
│  │  📍 Positioned (x, y calculado)           │ │
│  │  ┌─────────────────────────────────────┐ │ │
│  │  │ Material (dropdown)                 │ │ │
│  │  │ ┌─────────────────────────────────┐ │ │ │
│  │  │ │ 🔍 Campo de busca               │ │ │ │
│  │  │ └─────────────────────────────────┘ │ │ │
│  │  │ ────────────────────────────────── │ │ │
│  │  │ ☐ Turma A                           │ │ │
│  │  │ ☑ Turma B (selecionada)             │ │ │
│  │  │ ☐ Turma C                           │ │ │
│  │  │ ☐ Turma D                           │ │ │
│  │  └─────────────────────────────────────┘ │ │
│  └───────────────────────────────────────────┘ │
└─────────────────────────────────────────────────┘
         ↑
         └─ Posição calculada a partir do LayerLink
```

---

## Exemplo de Uso

```dart
class MeuFormulario extends StatefulWidget {
  @override
  State<MeuFormulario> createState() => _MeuFormularioState();
}

class _MeuFormularioState extends State<MeuFormulario> {
  final _formKey = GlobalKey<FormState>();
  final _turmaSelecionada = ValueNotifier<Turma?>(null);
  final List<Turma> _turmas = [
    Turma(id: 1, nome: 'Turma A'),
    Turma(id: 2, nome: 'Turma B'),
  ];

  @override
  void dispose() {
    _turmaSelecionada.dispose();
    super.dispose();
  }

  void _submeter() {
    if (_formKey.currentState?.validate() == true) {
      print('Turma selecionada: ${_turmaSelecionada.value?.nome}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SearchableDropdown<Turma>(
            controller: _turmaSelecionada,
            label: 'Turma',
            items: _turmas,
            itemAsString: (turma) => turma.nome,
            itemId: (turma) => turma.id,
            searchHint: 'Buscar turma...',
            isRequired: true,
            validator: (value) {
              if (value == null) return 'Turma é obrigatória';
              return null;
            },
            onChanged: (turma) {
              print('Turma mudou: ${turma?.nome}');
            },
          ),
          ElevatedButton(
            onPressed: _submeter,
            child: Text('Submeter'),
          ),
        ],
      ),
    );
  }
}
```

---

## Conclusão

O `SearchableDropdown` é um componente complexo que combina:

1. **LayerLink + CompositedTransformTarget**: Posicionamento dinâmico
2. **OverlayEntry**: Exibição flutuante sobre a UI
3. **Positioned**: Posicionamento absoluto preciso
4. **ValueNotifier + ValueListenableBuilder**: Reatividade
5. **FormField**: Integração com formulários
6. **GestureDetector**: Detecção de toques (dentro/fora)
7. **FocusNode**: Gerenciamento de foco

Todos esses componentes trabalham juntos para criar uma experiência de usuário fluida e robusta, com validação integrada e busca em tempo real.
