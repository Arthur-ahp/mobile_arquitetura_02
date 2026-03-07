# product_app
**1️- Em qual camada foi implementado o cache e por quê?**

O cache foi colocado na camada de data, no datasource de cache. Isso porque essa camada é responsável por buscar e guardar os dados, seja da API ou localmente. Assim o resto do sistema não precisa saber de onde os dados vem, só usa eles. Isso ajuda a manter o codigo mais organizado.


**2️- Por que o ViewModel não realiza chamadas HTTP diretamente?**

O ViewModel não faz chamada HTTP porque ele faz parte da camada de presentation, que cuida mais do estado da tela e da logica da interface. Se ele chamasse a API direto ia misturar muita responsabilidade no mesmo lugar. Então ele só conversa com o repository, que é quem busca os dados.


**3️- O que aconteceria se a interface acessasse diretamente o datasource?**

Se a interface acessasse direto o datasource, o codigo ficaria muito acoplado. A tela ia precisar saber como os dados são buscados e isso não é muito bom. Também ficaria mais dificil mudar alguma coisa depois, tipo trocar API ou outra fonte de dados.


**4️- Como essa arquitetura facilitaria a substituição da API por um banco de dados local?**

Como o ViewModel depende só do repository, da para trocar a forma de buscar os dados sem mudar o resto do sistema. Por exemplo, em vez de pegar da API poderia pegar de um banco local. A mudança ficaria só no repository ou datasource, sem precisar alterar a interface ou o ViewModel. Isso deixa o sistema mais flexivel e facil de manter.
