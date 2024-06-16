---
title: "Criando um editor de texto - parte 4"
layout: post
categories: editor-de-texto
---

Vamos partir para uma etapa de organização de código agora que já temos um visualizador de arquivos que funciona. No final deste texto teremos algo como o gif abaixo.

<video controls width="80%">
<source src="/assets/editor-de-texto/part4.mkv" type="video/mp4"/>
</video>

Os primeiros passos são melhorar nosso tipo `TermState`. Vamos colocar um pouco mais de informações nele e criar uma função `new` que cria um `TermState` a partir do conteúdo de um arquivo. 

```gleam
pub type TermState {
  TermState(
    fname: String,
    nlines: Int, 
    ncols: Int,
    before: queue.Queue(String),
    screen: queue.Queue(String),
    after: queue.Queue(String),
  )
}

pub fn new(fname: String, lines: String, nrows: Int, ncols: Int) -> TermState {
  let line_list = split_line_max_length(lines, ncols)
  TermState(
    fname, nrows, ncols,
    queue.new(),
    queue.from_list(list.take(line_list, nrows)),
    queue.from_list(list.drop(line_list, nrows)),
  )
}
```

Isso já simplifica um bocado o código do `main`, além de facilitar futuras implementações relacionadas à edição de arquivos. 

O outro passo é extrair o código das funções de rolagem da tela. Veja abaixo como ficaria o `scroll_down`.

```gleam
pub fn scroll_down(st: TermState) {
  case queue.pop_front(st.after) {
    Ok(#(line_show, new_after)) -> {
      let assert Ok(#(line_hide, new_screen)) = queue.pop_front(st.screen)
      Ok(#(
        line_show,
        line_hide,
        TermState(
          ..st,
          before: queue.push_back(st.before, line_hide),
          screen: queue.push_back(new_screen, line_show),
          after: new_after,
        ),
      ))
    }
    _ -> {
      Error(st)
    }
  }
}
```

Essa função usa o tipo [gleam/result](https://hexdocs.pm/gleam_stdlib/gleam/result.html), que representa uma operação que pode (ou não) dar erro. No nosso caso `scroll_down` dá erro quando chegamos no fim do arquivo (`state.after` está vazio).

O código que recebe a tecla seta para baixo também fica um pouco mais claro.

```gleam
terminal.CursorMovement(terminal.DOWN) -> {
  case term_state.scroll_down(state) {
	Ok(#(line_show, line_hide, new_state)) -> {
	 // atualiza interface do terminal
	 io.print("\u{1b}[1S")
	 terminal.move_cursor(state.nlines,0)
	 terminal.clear_line()
	 io.print(line_show)

	 // veremos isso mais para a frente hoje :)
	 repaint_bottom_bar(new_state, new_state.fname)
	 
	 input_loop(new_state)
	}
	Error(st) -> {
	 input_loop(st)
	}
  }
  
}
```

A parte final que faremos por hoje é pintar a linha verde na parte de baixo do console. A ideia é mostrar o nome do arquivo aberto e possívelmente outras informações úteis no futuro. A sacada para fazer isso é, basicamente, criar um `TermState` com uma linha a menos do que o disponível no terminal :)

```gleam
// no main
let st = term_state.new(filename, contents, nlines-1, ncols)

// e chamar a função abaixo sempre que rolar a tela
fn repaint_bottom_bar(state: TermState, fname) {
  terminal.move_cursor(state.nlines+1, 0)
  
  io.print("\u{1b}[48:5:2m")
  terminal.clear_line()
  io.print(" <gled> -- " <> fname <> " \u{1b}[0m")
}
```
O efeito é o do vídeo acima: uma barra verde fixa na parte de baixo do editor.

E é isso :) Temos agora um código um pouco (bem pouco) mais organizado antes de fazer a primeira parte difícil do editor: posicionar o cursor na tela e manter a informação de qual linha/coluna isso está mapeado no texto. O código final pode ser visto [no repo term_editor](https://github.com/igordsm/term_editor/tree/main/src/part4).

