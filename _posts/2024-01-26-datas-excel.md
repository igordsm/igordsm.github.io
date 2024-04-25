---
title: "Datas em formato Excel OpenXML usando Nim"
layout: post
categories: code
---

Representar  dados em computadores é uma tarefa que parece fácil mas que é na verdade bem complicada. Vou falar um pouco aqui sobre uma experiência que tive trabalhando com planilhas Excel na linguagem [Nim](https://nim-lang.org) com a biblioteca [xl](https://github.com/khchen/xl/).

Arquivos com extensão *.xlsx* estão no formato OpenXML, um padrão com especificação aberta que é basicamente um arquivo *zip* com estrutura fixa de pastas e uma porção de arquivos *.xml* dentro. Não é exatamente complicado e só de abrir e ler os nomex e conteúdos dos arquivos já daria para entender mais ou menos como as coisas funcionam.

Menos para datas... Datas já são um [tema bem complicado](https://infiniteundo.com/post/25326999628/falsehoods-programmers-believe-about-time), então ler datas em um arquivo externo é pedir pra sofrer.

Examinando os valores das células, vi que a data para o dia *22 de dezembro de 2023* terá o valor .... Não ajuda muito, certo? De acordo com a documentação do formato OpenXML, datas estão no formato *1900-compatibility mode*. A explicação rápida é que o número representa dias após a data base *01 de janeiro de 1900*. Isso não batia muito com minhas contas e [esse site](http://www.ericwhite.com/blog/dates-in-spreadsheetml/) muita coisa. No fim acabei encontrando também a [documentação oficial sobre este tópico](https://learn.microsoft.com/en-us/office/troubleshoot/excel/1900-and-1904-date-system), mas achei o primeiro link mais didático.

Para começar, a explicação rápida é enganosa. A data *01 de janeiro de 1900* tem valor **1**, portanto o número representa o número de dias após *31 de dezembro de 1899*. Pode ser intuitivo para não programadores, mas pra nós programadores que indexamos o primeiro elemento como 0 é bastante confuso.

Tem mais: infelizmente um software antigo e muito famoso na década de 80 e 90 chamado Lotus 123 criou essa representação, mas errou feio e considerou que 1900 era ano bisexto (e não é!). Assim, uma tonelada de planilhas foram criadas com a contagem de dias errada e os programas concorrentes precisavam ser capazes de ler e intrepretar esses dados. Por isso esse modo de armazenar datas é chamado *1900 compatibility mode*. É compatível com um software de 30 anos atrás que ninguém mais usa, mas que criou uma quantidade enorme de dados nesse formato e que precisam ser lidos...

![](https://winworldpc.com/res/img/screenshots/2e2a25fbb4a2f9b686b7b161059cfb5f7c568c8f5d572b6382f0ebe0fb8c35c7.png)

Aliás, olha só que doideira: nem os softwares de planilha mais usados (Excel, LibreOffice e OnlyOffice) concordam e e mostram datas diferentes para a mesma célula com data *05 de janeiro de 1900*. Pelo menos eles concordam quando a data passa de *01 de março de 1900*....

![](/assets/datas-diferentes-excel.png)

Vamos ver agora o código atual da `xl` que devolve um `datetime` a partir de uma célula com dados no formato que descrevi acima.

```nim
proc date*(xc: XlCell): DateTime =
  ## Assume the number of cell is a date and return it.
  ## Using 1900 date system: a serial number that represents the number of days
  ## elapsed since January 1, 1900.
  result = dateTime(1900, mJan, 1)
  result += initDuration(seconds = int(xc.number * 86400))
```

A intuição do código faz todo sentido: um dia tem `84600` segundos, então basta somar isso vezes o número de dias para chegar na data correta. Mas está errado :S O número de dias varia conforme a data é antes ou depois de 29 de fevereiro de 1900. Além disso,o dia 01 de janeiro de 1900 é o número sequencial **1**! 

Estou tentando me envolver novamente com projetos abertos e *Nim* é uma linguagem interessante. Por isso [enviei um PR](https://github.com/khchen/xl/pull/6) com uma correção (e testes!) e espero que seja aprovado logo. Estou usando essa lib em um projeto simples para converter planos de aula em arquivos *.ics* para colocar no meu calendário. Posto sobre isso quando estiver mais pronto.


