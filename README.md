# API de Filmes e Séries

<p align="justify">
API para importar dados de filmes e séries a partir de um arquivo CSV diretamente para uma tabela no banco de dados. Com esta API, você pode carregar informações de filmes, como título, país, ano de lançamento e descrição, e listar esses dados em formato JSON com filtros personalizados.
</p>

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

Na raiz do projeto, execute os seguintes comandos para configurar e iniciar o ambiente:

**Build da imagem Docker**
 ```docker
docker compose build
```

**Inicialização do ambiente**

 ```docker
docker compose up
```
A API estará disponível em http://localhost:3000.

### Endpoints

```
POST http://localhost:3000/load_movies   Carrega o conteúdo do csv para o banco de dados.
GET  http://localhost:3000/movies        Lista todos os filmes e séries salvos no banco de dados
```


Você pode aplicar filtros para buscar filmes e séries com base em critérios específicos, como título, país e ano de lançamento. Exemplos:

```
GET http://localhost:3000/movies?year=2020:                        Lista os filmes e séries lançados no ano de 2020.
GET http://localhost:3000/movies?title=The World Is Not Enough:    Mostra apenas o filme com esse título.
GET http://localhost:3000/movies?country=United States&year=2020:  Lista todos os filmes dos Estados Unidos lançados em 2020.
```

### Testes

Para executar os testes automatizados, na raiz do projeto, utilize o seguinte comando:
```docker
docker exec -it netflix_backend rspec
```

## Detalhes Técnicos

- **Ruby**: 3.0.2

- **Rails**: 7.0.8

- **PostgreSQL**: 13