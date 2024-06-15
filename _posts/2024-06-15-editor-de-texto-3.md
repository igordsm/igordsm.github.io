---
title: "Criando um editor de texto - parte 3"
layout: post
categories: editor-de-texto
---


Agora chegamos na parte interessante que vai juntar novidades tanto de terminal (como dispositivo de hardware) quanto programação funcional. Vejamos:

1. gleam não tem estado. Ou seja, vai ser necessário guardar quais linhas estão na tela e quais estão fora **sem modificar nenhuma variável**. Além disso, precisamos persistir essas modificações enquanto o usuário interage com o programa.
2. até agora só enviamos comandos para o terminal (via escape codes escritos na saída padrão). Agora vamos **receber** esses comandos também via entrada padrão.

Vamos tratar um problema de cada vez, começando com como guardar o estado do nosso editor.

## Representando o estado atual do editor 

A primeira parte é guardar quais linhas estão dentro e fora da tela. A imagem abaixo ajuda a entender um pouco a dinâmica de um programa que mostra um arquivo no terminal.

![Ilustração de um arquivo sendo mostrado no terminal](/assets/editor-de-texto/linhas-tela.png)

Logo, precisamos não só de uma lista de linhas, mas de 3: 

* `before` guarda as linhas que estão **antes** do trecho atualmente mostrado na tela. É vazio se a primeira linha está sendo mostrada ou se o arquivo for menor que o número de linhas do terminal
* `screen` guarda as linhas que estão sendo mostradas na tela **neste momento**
* `after` guarda as linhas que estão **depois** do trecho mostrado na tela atualmente. É vazio se a última linha está sendo mostrada ou se o arquivo for menor que o número de linhas do terminal

Uma vantagem dessa representação é que rolar a tela é muito fácil! 

* para descer a tela precisamos transferir a última linha de `screen` para o início de `after` e transferir a última de `before` para o início de `screen`.
* para subir a tela precisamos transferir a primeira linha de `screen` para o fim de `before` e transferir a primeira de `after` para o fim de `screen`.

*gleam* possui o tipo [queue](https://hexdocs.pm/gleam_stdlib/gleam/queue.html), que permite adicionar/remover elementos de maneira eficiente no início e fim da coleção de dados. Portanto, o estado do nosso programa será uma tripla com esses três elementos.

```gleam
type TermState {
  TermState(
    before: queue.Queue(String),
    screen: queue.Queue(String),
    after: queue.Queue(String),
  )
}
```

Esse estado agora será passado para a função `input_loop` e pode ser modificado pela entrada do usuário. Iniciamos o loop principal como mostrado abaixo:

```gleam
let st =
TermState(
  queue.new(),
  queue.from_list(list.take(contents_split_lines, nlines)),
  queue.from_list(list.drop(contents_split_lines, nlines)),
)
terminal.move_cursor(0, 0)

terminal.raw_mode_enter()
input_loop(st)
terminal.raw_mode_end()
```

Rolar a tela para baixo pode ser implementado, portanto, com o código abaixo.

```gleam
case queue.pop_back(state.before) {
	Ok(#(line_show, new_before)) -> {
	  io.print("\u{1b}[1T") // escape code para o terminal rolar para baixo
	  terminal.move_cursor(0, 0)
	  io.print(line_show)
	  let assert Ok(#(line_hide, new_screen)) = queue.pop_back(state.screen)
	  input_loop(TermState(
		new_before,
		queue.push_front(new_screen, line_show),
		queue.push_front(state.after, line_hide),
	  ))
	}
	_ -> input_loop(state)
```

## Recebendo teclas não alfanuméricas

Agora que já podemos rolar a tela precisamos ler as setinhas do teclado e completar a funcionalidade que precisamos implementar. Felizmente essa é uma tarefa fácil. 

Os mesmos códigos que enviamos para o terminal podem ser recebidos dependendo das teclas pressionadas. Os que nos interessam são os seguintes:

| Tecla          | Escape Code |
| -------------- | ----------- |
| CURSOR UP      | `ESC [ A`   |
| CURSOR DOWN    | `ESC [ B`   |
| CURSOR FORWARD | `ESC [ C`   |
| CURSOR BACK    | `ESC [ D`   |
Podemos fazer isso mudando a função `get_key` que construímos anteriormente. Agora ele pode retornar ou uma letra (tipo `String`) ou um comando para mover o cursor. Conseguimos representar isso com os seguintes tipos em *gleam*. Note que incluímos a possibilidade `UNKNOWN` para caso algum comando não suportado (ainda) seja enviado pelo terminal. 

```gleam
pub type CursorDirection {
  UP
  DOWN
  LEFT
  RIGHT
}

pub type Key {
  Letter(char: String)
  CursorMovement(dir: CursorDirection)
  UNKNOWN
}
```

Nossa função `get_key` muda para a seguinte. Agora ela devolve o tipo `Key` e checa se o caractere lido é um `ESC`. Se, for chama a função `read_escape_sequence` que faz a leitura do restante do escape code. Se não só devolve o caractere lido com o construtor `Letter`. 

```gleam
pub fn get_key() -> Key {
  case get_chars("", 1) {
    "\u{1b}" -> read_escape_sequence()
  	letter -> Letter(letter)
  }
}

fn read_escape_sequence() {
	get_chars("", 1) // read [
	case get_chars("", 1) {
		"A" -> CursorMovement(UP)
		"B" -> CursorMovement(DOWN)
		"C" -> CursorMovement(RIGHT)
		"D" -> CursorMovement(LEFT)
		_ -> UNKNOWN
	}
}
```

## Juntando tudo 

Para juntar tudo basta mexer em `input_loop` para que o estado seja passado sempre na função recursiva e que chequemos as setas além de letras. Veja abaixo uma parte dessa função.

Um ponto interessante é que se não há nenhuma alteração no estado do programa basta fazer a chamada recursiva com o mesmo estado que foi recebido. É tudo bem claro e não há mudanças "escondidas".

```gleam
fn input_loop(state: TermState) {
  case terminal.get_key() {
    terminal.CursorMovement(terminal.UP) -> {
      case queue.pop_back(state.before) {
        Ok(#(line_show, new_before)) -> {
          io.print("\u{1b}[1T")
          terminal.move_cursor(0, 0)
          io.print(line_show)
          let assert Ok(#(line_hide, new_screen)) = queue.pop_back(state.screen)
          input_loop(TermState(
            new_before,
            queue.push_front(new_screen, line_show),
            queue.push_front(state.after, line_hide),
          ))
        }
        _ -> input_loop(state)
      }
    }
	// checar seta para baixo
	terminal.Letter("q") -> Nil
    _ -> input_loop(state)
}
```

Um passo interessante aqui seria reorganizar esse código em módulos para podermos deixar o código mais legível e organizado. Iremos fazer isso na próxima parte, já que precisaremos extender o estado do editor para incluir posição do cursor.
