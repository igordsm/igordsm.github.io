---
title: "PSP: alguns experimentos com desenvolvimento de software"
layout: post
categories: psp
---

Depois de desnterrar meu PSP após algumas oconveras com alunos resolvi ligá-lo e brincar um pouco com ele. É um console portátil estranhamente pequeno para os padrões atuais, sendo ligeiramente menor que meu ceuluar e ridiculamente menor que um SteamDeck

![](/assets/psp/foto-sdl.jpeg)

Por gostar de tecnologias abertas e afins, sempre tive instalados alguns homebrew no meu PSP. Só pela diversão resolvi hoje tentar compilar pacotes para o PSP. Não é algo exatamente comum de se fazer, mas gosto de aprender a programar em plataformas  não convencionais. 

Uma coisa sensacional do PSP é a evolução das ferramentas desenvolvimento não oficiais: [PSPdev](https://pspdev.github.io/). Não só várias bibliotecas relevantes para jogos como SDL2 e Lua tem versões para PSP como também é possível gerar jogos e programas que rodam também em PSPs que não usam Custom Firmware (ou seja, que não foram hackeados). Vou fazer um guia básico aqui de como fiz para compilar e rodar um dos exemplos do site diretamente no meu PSP.

[Tudo o que foi feito está disponível neste repositório do github](https://github.com/igordsm/psp-sdl2-with-docker/tree/main). Os comandos nessa página usam esses arquivos como referência.

Para  facilitar a vida procurei primeiro por algum docker file ou release binário e encontrei esse repo: [ticky/docker-pspdev](https://github.com/ticky/docker-pspdev/). Tentei rodar diretamente, mas não funcionou pela imagem estar baseada em Ubuntu 12.04, que não tem mais repositórios online. Atualizei a imagem para 22.04 e mudei um pouquinho as dependências, conseguindo rodar comandos básicos na imagem de resultado.

Para ter um shell com tudo instalado basta rodar 

```
docker run -v $PWD:/src/  -it --rm igormontagner/pspdev
```

O código da pasta atual já estará disponível na pasta `/src`. Useis dois exemplos disponíveis no site do PSPdev: um com as bibliotecas nativas do PSP e outro com SDL2 (biblioteca multiplataforma muito usada). Para compilar ambos é só executar os comandos abaixo. Como estamos usando docker, fica muito fácil rodar somente ou ou dois comandos dentro do container e assim não precisamos nem criar uma sessão interativa :D

```
mkdir build && cd build
psp-cmake ..
make
```

Isso deve ter criado um arquivo `EBOOT.PBP` na pasta `build`. É esse arquivo que representa um jogo no PSP. Para fazê-lo executável pasta ligar o PSP no PC, criar uma pasta `SDL` dentro da pasta `/GAME` e copiar o `EBOOT.PBP` para lá. 

<video width="600" controls>
    <source src="/assets/psp/demo-sdl.mp4" type="video/mp4" />
</video>

E é isso! Não é complicado codar e rodar programas no PSP e é essa uma das razões que a cena Homebrew foi tão forte nesse console. Olha só a quantidade de [apps](https://www.gamebrew.org/wiki/List_of_PSP_homebrew_applications) e [jogos](https://www.gamebrew.org/wiki/List_of_PSP_homebrew_games) homebrew! Alguns deles ainda são atualizados e existe até um port experimental da engine Godot :O

