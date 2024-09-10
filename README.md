# 🐌 LesmaGram

Uma nova rede social aberta a todos os nichos! 🌍. Aplicação desenvolvida para disponibilizar publicação de imagem aos usuários.

## Sumario

-   [Dependências](#dependências)
-   [Funcionalidades do sistema](#funcionalidades-do-sistemas)
-   [Como executar](#como-executar)
-   [Colaboradores](#colaboradores)

## Dependências

-   [NodeJS](https://nodejs.org/en/download/package-manager) v22.11
-   [Flutter](https://docs.flutter.dev/get-started/install) v3.24
-   [Docker](https://docs.docker.com/engine/install/) v27.1.1

## Funcionalidades do Sistemas

-   Publicar imagens
-   Alterar postagens do próprio perfil
-   Interagir com outras publicações (Curtir)
-   Excluir publicações
-   Visualizar publicações curtidas
-   Editar informações do Perfil (nome de usuário, email e senha)
-   Encontrar outros usuários (Pesquisa pelo nome de usuário)
-   Visualizar perfis de outros usuários
-   Navegar com perfil Anônimo (Sem a necessidade de escolher um nome de usuário.)

## Como executar

Para subir a aplicação é necessário executar [criação do banco](#criação-banco-de-dados), [executar o backend](#execução-do-backend), e [executar o frontend](#execução-do-frontend), nessa ordem. Os passos para executar cada uma das etapas estão descritos abaixo.

### Criação Banco de Dados

Execute `docker compose up` para criar o banco de dados utilizado um container docker. Abra o banco em um gerenciador de banco de dados e execute o script de criação das tabelas disponivel em [./architecture/migrations.pgsql](./architecture/migrations.pgsql)

### Execução do Backend

```bash
    # Para verificar versão do nodejs (Nessário v22.2.0)
    $ node -v

    # Para entrar na pasta do backend
    $ cd backend

    # Para instalar as dependências
    $ npm ci

    # Para iniciar o servidor
    $ npm run dev
```

### Execução do Frontend

```bash
    # Para verificar versão do flutter (nessário v3.24.1)
    $ flutter --version

    # Para entrar na pasta do frontend
    $ cd frontend

    # Para instalar as dependências
    $ flutter pub get

    # Para iniciar o cliente
    $ flutter run
```

## Colaboradores

<center>
<table><tr>

<td align="center" ><a href="https://github.com/anellykovalski">
 <img style="border-radius: 50%; margin-top: 15px;" src="https://avatars.githubusercontent.com/u/124692976?v=4" width="100px;" alt=""/>
<br />
 <b>Anelly Kovalski Santana</b></a>
 <a href="https://github.com/jhonatancunha" title="Repositorio Jhonatan"></a>

<td align="center"><a href="https://github.com/caiotheodoro">
 <img style="border-radius: 50%;margin-top: 15px;" src="https://avatars.githubusercontent.com/u/48462974?v=4" width="100px;" alt=""/>
<br />
 <b>Caio Eduaro Theodoro Da Silva</b>
 </a> <a href="https://github.com/caiotheodoro" title="Repositorio Jessé"></a>

<td align="center"><a href="https://github.com/DiogoRodriguees">
 <img style="border-radius: 50%;margin-top: 15px;" src="https://avatars.githubusercontent.com/u/92277603?v=4" width="100px;" alt=""/>
<br />
 <b>Diogo Rodrigues Dos Santos</b>
 </a> <a href="https://github.com/DiogoRodriguees" title="Repositorio Iago"></a>

<td align="center"><a href="https://github.com/eduardo-riki">
 <img style="border-radius: 50%;margin-top: 15px;" src="https://avatars.githubusercontent.com/u/67388437?v=4" width="100px;" alt=""/>
<br />
 <b>Eduardo Riki Matushita</b>
 </a> <a href="https://github.com/eduardo-riki" title="Repositorio Iago"></a>

</tr></table>

</center>
