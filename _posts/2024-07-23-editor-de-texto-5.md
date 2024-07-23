---
title: "Criando um editor de texto - parte 5"
layout: post
categories: editor-de-texto
---

O visualizador já está pronto, agora é começar a editar! Vamos então começar a editar texto e nosso primeiro exemplo será bem simples: editar uma única linha, incluindo usar as setas para esquerda e direita para posicionar o cursor. O resultado fica parecido com o abaixo. 


<video controls width="80%">
<source src="/assets/editor-de-texto/part5.mkv" type="video/mp4"/>
</video>


Nosso primeiro passo será definir um tipo `EditableString`. Isso é necessário pois modificar uma String acarreta na criação de uma nova String. Por isso iremos tratar nosso texto como uma lista de [grafemas](https://pt.wikipedia.org/wiki/Grafema). Outro ponto: saber o tamanho da nossa string é importante, por isso iremos guardar esse valor no nosso tipo. O algoritmo [list.length](https://hexdocs.pm/gleam_stdlib/gleam/list.html#length) em Gleam é $\mathcal{O}(n)$, então seria legal evitar passar pela lista inteira só para pegar seu tamanho. 

```gleam
pub type EditableString {
  EditableString(text: List(String), total_length: Int)
}

pub fn new() {
  EditableString([], 0)
}
```

A partir desse texto iremos tentar aproveitar melhor as funções da biblioteca padrão de Gleam e escrever código que aproveite o módulo [list](https://hexdocs.pm/gleam_stdlib/gleam/list.html). Vejamos um exemplo simples que mostra nossa string no terminal.

```gleam
pub fn print(es: EditableString) {
  list.each(es.text, io.print)
}
```

A função [list.each](https://hexdocs.pm/gleam_stdlib/gleam/list.html#each) aplica uma função a cada elemento do primeiro argumento e descarta o resultado. Isso é perfeito para o nosso caso, em que queremos chamar a mesma função para todo elemento da lista. Daria para fazer com a recursão que já usamos em outros textos, mas fica bem mais comprido...

```gleam
pub fn print(es: EditableString) {
  [] -> Nil
  [first, ..rest] -> {
    io.print(first)
    print(rest)
  }
}
```

A inserção também pode ser feita com funções de `list` e fica bem curtinha :) As funções `take` e `drop` são relativamente explicativas, então vou focar no `flatten`. Ele pega uma lista de listas e transforma em uma lista com um nível só. Super útil no caso abaixo, que ficamos com uma lista com três pedaços do texto. 

```gleam
pub fn insert_at_cursor(es: EditableString, pos, str) {
  let sl = es.text
  let new_list =
    [list.take(sl, pos), string.to_graphemes(str), list.drop(sl, pos)]
    |> list.flatten
  EditableString(new_list, es.total_length + string.length(str))
}
```

A etapa final é criar o loop de eventos e garantir que o cursor aponta para o lugar certo. Veja abaixo.

```gleam
fn input_loop(es: EditableString, cursor: Int) {
  case terminal.get_key() {
    terminal.CursorMovement(terminal.LEFT) -> {
      let new_cursor = int.max(cursor - 1, 1)
      terminal.move_cursor(0, new_cursor)
      input_loop(es, new_cursor)
    }
    terminal.CursorMovement(terminal.RIGHT) -> {
      let new_cursor = int.min(es.total_length + 1, cursor + 1)
      terminal.move_cursor(0, new_cursor)
      input_loop(es, new_cursor)
    }
    terminal.Letter(s) -> {
      terminal.clear_line()
      let new_es = editable_string.insert_at_cursor(es, cursor - 1, s)
      terminal.move_cursor(0, 1)
      editable_string.print(new_es)
      terminal.move_cursor(0, cursor + 1)
      input_loop(new_es, cursor + 1)
    }
    terminal.Enter -> Nil
    terminal.UNKNOWN -> Nil
    _ -> Nil
  }
}
```

Apertar `Enter` finaliza a edição da linha. Esse código ainda tem alguns problemas:

1. se a linha ficar maior que o terminal o cursor vai ficar piscando no fim da linha 1, porém o texto vai ser editado no lugar correto. 
2. o cursor fica sempre na primeira linha. 
3. não há nenhum tratamento para o número de linhas no terminal que o texto ocupa. 

Porém, já temos um grande avanço em termos de interação. Juntar isso com o visualizador ainda vai dar trabalho e isso fica pros próximos textos :P 