---
title: "Criando um editor de texto - parte 1"
layout: post
categories: editor-de-texto
---

Eu gosto de editores de texto.Mesmo. Já testei uma porção deles e de todos os tipos, desde neovim e Emacs até os menos conhecidos como helix e micro. Também uso editores de texto GUI e já experimentei um monte deles. Aliás, minhas contribuições mais complexas no elementary linux foram justamente no editor de texto Code.

Resolvi então explorar como construir um editor de texto do zero. E não só isso: um editor de texto que funcione no terminal. Meus dois objetivos com isso são

1. explorar os tipos de algoritmos envolvidos na criação de um editor de texto
1. usar a linguagem funcional Gleam para construir um programa complexo

A cada novo texto irei contando um pouco deste processo e teremos uma versão mais sofisticada do editor. Aliás, nas primeiras versões nosso "editor" não vai nem modificar os arquivos, só mostrá-los.

Essa é uma outra vantagem de construir no terminal: ter a chance de se aprofundar em problemas que já são resolvidos completamente por outras bibliotecas. Por exemplo, um GtkSourceView já possui recursos prontos para syntax highlight e auto complete. Isso ajuda a criar um editor rápido e poupa um grande trabalho, mas não necessariamente ajuda a aprender como resolver esses problemas.

Essa parte 1 da série explica um pouco sobre o que é um terminal em sistemas POSIX e como podemos controlá-lo para criar programas complexos.

Para começar, todo programa de terminal como Gnome Console ou Konsole emula um dispositivo terminal "de verdade" (físico mesmo) que estava ligado ao sistema principal via rede. Nessa configuração o terminal (e seu teclado) podia estar conectado ao sistema via linha telefônica e estar a quilômetros de distância.

Obviamente o terminal podia exibir caracteres e receber entrada via teclado. O que não é tão óbvio é que o terminal também pode ser controlado via sequências especiais de bytes. Podemos mudar as cores do texto e do fundo, posicionar o cursor em qualquer lugar da tela e rolar todas as linhas para cima (ou para baixo). Em terminais modernos conseguimos também mostrar caracteres unicode (com acentos, orientais e/ou ícones). Ou seja, o terminal é excelente para programas que tratam texto e pode ser muito interativo. Dá até para habilitar suporte a mouse!

Uma outra vantagem do terminal é que os programas podem ser muito leves. As opções de layout são limitadas e a interação em geral é diferente de programas gráficos. Um exemplo clássico é a rolagem de tela: vários programas otimizam ao máximo essa operação, porém o terminal funciona em um esquema de páginas em que a maioria das rolagens de tela apagam pelo menos metade do texto. Ou seja, o que pode ser importante para conteúdos ricos em gráficos e interações via toque também pode ser irrelevante em uma aplicação que só trabalha com texto.

Vamos então a como controlar o terminal. Temos uma série de sequencias especiais que começam com dois caracteres de controle. Ao enviar os bytes `ESC`+`[` o terminal irá interpretar a sequência de bytes seguintes como um comando.

* `ESC[2J` limpa a tela inteira
* `ESC[L;CH` move o cursor para a linha L e coluna C
* `ESC[1m` liga o modo negrito. Todo texto a seguir será escrito em negrito
* `ESC[0m` reseta para o formato padrão do terminal
* `ESC[38;2;127;255;255m` muda a cor para RGB(127, 255, 255)
Também temos códigos de controle com 1 caracter só, que são enviados com a tecla Ctrl pressionada. Por exemplo, Ctrl+J envia um caracter de nova linha para o terminal. A Wikipedia tem uma lista não exaustiva de códigos de controle.

Isso já nos permite escrever programas que mostram textos coloridos e posicionam o cursor em qualquer lugar da tela! Veja o exemplo abaixo em Gleam

{% highlight gleam %}
import gleam/io  
  
pub fn main() {  
 io.print("\u{1b}[10;5H \u{1b}[1m IGOR!\u{1b}[0m normal!")  
 io.print("\u{1b}[38;2;127;255;255mCOR!")  
    
}
{% endhighlight %}

É feio? Muito, mas podemos melhorar muito a legibilidade com funções. O exemplo abaixo é bem mais legível.

{% highlight gleam %}
import gleam/io  
  
fn bold(s) {  
  "\u{1b}[1m" <> s <> "\u{1b}[0m"  
}  
  
pub fn main() {    
 io.println(bold("IGOR") <> " normal")     
}
{% endhighlight %}


Um aspecto final do funcionamento do terminal é o tratamento da entrada (line discipline, em linux). A maneira padrão é o modo cooked, em que o terminal só envia os dados entrados pelo usuário após a tecla Enter ser pressionada. Também podemos habilitar o modo raw, em que toda tecla é disponibilizada instantâneamente para o programa.



> :warning: A rigor cada modo é um conjunto de opções mais simples oferecidas pelo kernel do Linux para configurar o terminal.

É possível usar a API posix para configurar o terminal, mas nesse momento vamos facilitar nossa vida e usar a ferramenta de comando ˋsttyˋ. Ela permite configurar todas opções do terminal e pode ser chamada em Gleam usando o pacote shellout. O exemplo abaixo mostra um programa que limpa o terminal, o coloca em modo raw, e mostra na linha 3 coluna 0 o último caractere digitado. O programa para quando digitamos q.

{% highlight gleam %}
import gleam/int  
import gleam/io  
import gleam/result  
import shellout  
  
@external(erlang, "io", "get_chars")  
pub fn get_chars(prompt: String, count: int) -> String  
  
fn clear() {  
 io.print("\u{1b}[2J")  
}  
  
fn raw_mode_enter() {  
 shellout.command("stty", ["raw", "-echo"], ".", [])  
}  
  
fn raw_mode_end() {  
 shellout.command("stty", ["-raw", "echo"], ".", [])  
}  
  
fn move_cursor(row: Int, col: Int) {  
 io.print("\u{1b}[" <> int.to_string(row) <> ";" <> int.to_string(col) <> "H")  
}  
  
fn input_loop() {  
 let k = get_chars("", 1)  
 case k {  
   "q" -> Nil  
   _ -> input_loop()  
 }  
}  
  
pub fn main() {  
 clear()  
 raw_mode_enter()  
 move_cursor(3, 0)  
 input_loop()  
 raw_mode_end()  
}
{% endhighlight %}


Esse controle do terminal já nos dá quase tudo que precisamos para criar um editor de texto! No próximo texto falarei de arquivos e acabaremos com um "visualizador" de arquivos. Até :)