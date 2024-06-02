---
title: "Criando um editor de texto - parte 2"
layout: post
categories: editor-de-texto
---

O próximo passo da série de editor de texto em linha de comando é receber argumentos na linha de comando e abrir arquivos. Vamos já preparar o terreno também para 


Receber argumentos é bem simples. O pacote [argv](https://hexdocs.pm/argv/) faz isso e usar com *pattern matching* faz o código ficar bem legível. Veja abaixo a nova função `main`.

```gleam
pub fn main() {
  case argv.load().arguments {
    [filename] -> start_editor(filename)
    _ -> io.println("Usage: file_viewer filename")
  }
```

A função `start_editor` faz a leitura do arquivo passado na linha de comando e o mostra na saída. Também bem simples, cortesia do pacote [simplifile](https://hexdocs.pm/simplifile/) :) Um novidade aqui é o módulo `terminal`. Colocamos as funções desenvolvidas na parte anterior nesse arquivo para ficar mais organizado.

```gleam
fn start_editor(filename) {
  let assert Ok(contents) = simplifile.read(filename)

  terminal.clear()
  io.print(contents)
  terminal.move_cursor(0, 0)
  terminal.raw_mode_enter()
  input_loop()
  terminal.raw_mode_end()
  Nil
}
```

Isso já faz algo bem básico: mostra um arquivo na saída do terminal e espera pela tecla `Q` para terminar o programa. Porém, se o arquivo for maior que o tamanho do terminal a tela rola e não conseguimos ver o começo! O terminal automaticamente quebra linhas quando enviamos dados, porém ao criar um editor queremos controlar essas quebras. 


O comando `stty` também devolve o tamanho do terminal. Então podemos adicionar a função `get_size` abaixo em `terminal.gleam` para capturar o tamanho atual do terminal. O comando `let assert` usa *pattern matching* e dá erro se o padrão não bater. É uma maneira meio feia de se tratar o erro, mas deixa bem claro que **se falhar o programa vai crashar**.

```gleam
pub fn get_size() {
  let assert Ok(output) = shellout.command("stty", ["size"], ".", [])
  let assert Ok(#(lines, cols)) = string.split_once(output, " ")

  let assert Ok(lines) = int.base_parse(lines, 10)
  let assert Ok(cols) = int.base_parse(string.trim(cols), 10)

  #(lines, cols)
}
```

Agora o desafio vai ser transformar a string `contents` (com o conteúdo do arquivo) em uma lista de strings em que cada uma tenha no máximo a largura atual do terminal. Isso nos ajuda a contar quantas linhas vão ser efetivamente usadas quando mostrarmos o arquivo. 

O pacote [gleam/string](https://hexdocs.pm/gleam_stdlib/gleam/string.html) já tem uma função `split`, então o trabalho maior será processar cada linha do arquivo e, se necessário, criar uma nova lista com um ou mais "linhas virtuais" para aquela linha do arquivo. Veja um exemplo abaixo em que o tamanho máximo seria 5.

```
Entrada
["abcdefgh", "abc"]
Saída
["abcde", "fgh", "abc"]
```

Esse algoritmo vai ficar bem diferente por estarmos escrevendo em uma linguagem funcional. Pra começar *Gleam* não tem loops, é tudo recursivo. Além disso todas variáveis são imutáveis, então não dá para simplesmente adicionar ou remover elementos de uma lista. É necessário *criar uma nova lista sem/com o elemento*! Apesar de isso parecer tornar o código muito mais complicado, eu vou argumentar que na verdade ele fica mais simples. Sim, isso mesmo. Vem comigo.

Vamos dividir o algoritmo de criar as "linhas virtuais" em 3 casos:

1. a lista de linhas está vazia. Devolva então uma lista vazia. 
2. o primeiro elemento tem tamanho menor que o máximo `M`. Crie uma nova lista com o primeiro elemento intacto e chame recursivo no resto da lista. 
3. o primeiro elemento tem tamanho maior que o máximo `M`. Crie uma nova lista com três "pedaços":
  1. os primeiros `M` elementos do atual
  2. chame recursivo em uma nova lista com o restante do elemento atual mais o restante da lista original.

Pronto. Só isso! Veja agora o algoritmo `split_long_lines` escrito em *Gleam*

```gleam
fn split_long_lines(line_list, max_length) {
  case line_list {
    [] -> []
    [current, ..rest] -> {
      let curr_length = string.length(current)
      case curr_length {
        l if l < max_length -> [current, ..split_long_lines(rest, max_length)]
        l -> {
          [string.slice(current, 0, max_length), ..split_long_lines([string.drop_left(current, max_length), ..rest], max_length)]
        }
      }
    }
  }
}
```

A descrição em código é basicamente igual ao código :D Três casos, cada um retornando uma nova lista. Só é realmente feito algo quando a linha atual é maior que o tamanho máximo. 

Isso já praticamente resolve nosso problema! Com as linhas agora com tamanho máximo na largura do terminal, podemos só chamar [`list.take`](https://hexdocs.pm/gleam_stdlib/gleam/list.html#take) e pegar as primeiras `nlines`.  Veja o resultado final abaixo. 

```gleam
fn start_editor(filename) {
  let assert Ok(contents) = simplifile.read(filename)
  let #(nlines, ncols) = terminal.get_size()
  let contents_split_lines = split_line_max_length(contents, ncols)

  terminal.clear()
  io.print(string.join(list.take(contents_split_lines, nlines), "\n"))
  terminal.move_cursor(0, 0)

  terminal.raw_mode_enter()
  input_loop()
  terminal.raw_mode_end()
  Nil
}
```

Agora são mostradas as primeiras linhas do arquivo até encher o terminal. O próximo passo é agora ler as setinhas do terminal e reagir, mostrando mais linhas no topo ou na parte de baixo da tela. Vamos fazer isso no próximo texto, já que precisaremos guardar o **estado** (trecho do arquivo sendo mostrado) do programa durante sua execução. E como só temos variáveis constantes, vai ser necessário pensar um pouco mais sobre a organização do nosso programa. Até mais. 
