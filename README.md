# API de Filmes e Séries

API eficiente para importar dados de filmes e séries a partir de um arquivo CSV diretamente para uma tabela no banco de dados. Com esta API, você pode facilmente carregar informações de filmes, como título, país, ano de lançamento e descrição, e em seguida listar esses dados em JSON.

## Configuração

Após clonar o projeto, certifique-se  de que tenha o Docker e o Docker Compose instalados.
Confira os tutorias disponíveis em:

### Linux
> Docker Docs  <https://docs.docker.com/engine/install/>
> 
> Docker Docs  <https://docs.docker.com/engine/install/linux-postinstall/>

### Windows
>Docker Docs <https://docs.docker.com/desktop/setup/install/windows-install/>

### Mac

>Docker Docs <https://docs.docker.com/desktop/setup/install/mac-install/>

## Execução

Na raíz do projeto execute os seguintes comandos:

 ```docker
docker compose build
```

Em seguida:

 ```docker
docker compose up
```
A API estará disponível em http://localhost:3000.

### Endpoints

```
http://localhost:3000/load_movies   Carrega o conteúdo do csv para o banco de dados.
http://localhost:3000/movies        Lista todos os filmes e séries salvos no banco de dados
```


Os filmes e sséris podem ser visualizados de forma personalizda utilizando filtros por título, páis, ano de lançamento, dessa forma:

```
localhost:3000/movies?year=2020:                        Lista os filmes e séries lançados no ano de 2020.
localhost:3000/movies?title=The World Is Not Enough:    Mostra apenas o filme com esse título.
localhost:3000/movies?country=United States&year=2020:  Lista todos os filmes dos Estados Unidos lançados em 2020.
```

### Testes

Para executar os teste use o comando:
```docker
docker exec -it netflix_backend bash
```

## Detalhes

```
Ruby Version 3.0.2
Rails Version 7.0.8
Postgres Version 13
```
