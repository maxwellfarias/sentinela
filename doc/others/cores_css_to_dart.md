

## 🎨 Conversão de Cores CSS para Dart

Primeiro, analise o arquivo `index.css` e converta todas as cores definidas nele para propriedades estáticas da classe `NewAppColors` no arquivo `new_colors.dart`.
**ARQUIVO ALVO**: `lib/ui/core/themes/new_colors.dart` 
**ARQUIVO CSS**: `lovable/src/index.css`
Após anexar os arquivos, cole o prompt abaixo:

'''
1. Analise as cores contidas no arquiv index.css;
2. Faça uma verificação no arquivo new_colors.dart e converta as cores do arquivo index.css para o tipo Color como propriedade estática da classe NewAppColors conforme o modelo das propriedades que já estão no NewAppColors. Se no arquivo index.css já tiver uma cor com o mesmo nome de alguma propriedade da classe  NewAppColors, verifique se a cor é a mesma, se sim mantenha a cor que está em NewAppColors, caso não seja a mesma cor, atualize a propriedade da cor em NewAppColors. Caso essa cor ainda não exista em NewAppColors, adicione-a.
'''


Após usar o prompt acima, siga as orientações abaixo a fim de atualizar as cores que estão sendo usadas no tema do aplicativo:

1. Anexe os arquivos `new_colors.dart`, `theme.dart` e `new_color_extension.dart` e cole o prompt abaixo:

'''
1. Faça com que a classe NewAppColorTheme tenha somente as referências de cores descritas no arquivo new_colors.dart. Atualizar não só as propriedades da classe NewAppColorTheme bem como todas as referências dessas cores dos demais métodos da classe NewAppColorTheme;
2. Verifique todas as cores que fazem referência ao tema escuro que estão no arquivo new_colors.dart e use-as na declaração das cores do NewAppColorTheme declaradas como extension do AppTheme do modo escuro;
'''