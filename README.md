<div align='center'>
  
  # LEIA-ME
</div>

<br>


<div align='center'>

  ![Sem título](https://github.com/RenatoRosaFranco/pokeapi-challenge/assets/6882872/ce5ebf11-9843-4b0a-b57f-985136fb9ee1)

  
</div>

<br>

<div align='center'>
  
  # ZRP Challenge
</div>

Challenge desenvolvido como teste de conhecimento da empresa ZRP, no cenário sugerido, foi proposto o desenvolvimento de um
end-point que consumirá uma API externa, assim trazendo so os dados interessantes a serem desenvolvidos em nossa api.

<br>

<div align='center'>
  
  # ARQUITETURA
</div>

A arquitetura utilizada neste projeto consiste simplesmente em **4 Pilares principais**, O controller **(Pokemons)** responsavel por fazer a chamada
a API externa do **PokéAPI** através do interactor **FetchApiInteractor**, este interactor requisita o service de consulta a api externa chamado
de **PokemonServiceApi**, que retorna ao controller a resposta da requisição e em caso de sucesso renderiza o serializer **(PokemonSerializer)** como camada 
de apresentação da estrutura da **response**, que apresenta apenas as **habilidades** do pokemon em um array ordenado por nome.

<br>

![Captura de tela de 2023-09-19 02-06-15](https://github.com/RenatoRosaFranco/pokeapi-challenge/assets/6882872/93ec45ee-7a01-4441-9942-a94a47ce759a)


<br>

#### EXEMPLO:
Dada a chamada:
```
http://localhost:3000/api/v1/pokemons/:nome_pokemon
http://localhost:3000/api/v1/pokemons/charmander  # exemplo
```

<br>

A Resposta da API devera ser
```
{
  "abilities": [
    "lightning-rod",
    "static"
  ]
}
```

<br>

A Api devera devolver essa estrutura contendo as habilidades do pokemon, sendo mostradas por ordem alfabética
Abaixo uma lista para você realizar requisições para testar o endpoint com outros pokemons

<br>

<div align='center'>
  
  | Pokemon    | 
  |------------|
  | ditto      |
  | venusaur   |   
  | blastoise  | 
</div>

<br>

<div align='center'>
  
  # IMAGENS
</div>

<br>

Abaixo você pode acompanhar uma Screenshot de uma requisição realizada ao endpoint com o pokemon **Pikachu**

<br>

### Pikachu
![Captura de tela de 2023-09-19 00-58-08](https://github.com/RenatoRosaFranco/pokeapi-challenge/assets/6882872/37403de9-ee44-40ad-89bb-7eb223fb2196)

### Charmander
![Captura de tela de 2023-09-19 01-38-26](https://github.com/RenatoRosaFranco/pokeapi-challenge/assets/6882872/bee81746-8faa-415d-a181-fdc02a16c123)

### Squirtle
![Captura de tela de 2023-09-19 01-41-34](https://github.com/RenatoRosaFranco/pokeapi-challenge/assets/6882872/0c800e69-7447-4453-96f2-6aade08c81db)

### Não encontrado (Frodo)
![Captura de tela de 2023-09-19 01-47-31](https://github.com/RenatoRosaFranco/pokeapi-challenge/assets/6882872/721feb4a-bf81-4bb4-a634-16838383201e)


<br>

<div align='center'>

  # VERSÃO DO RUBY
</div>

<br>
  
Este projeto foi desenvolvido utilizando a **Versão** 3.0.0 do **Ruby**

```
3.2.0
```

<br>

<div align='center'>
  
  # DEPENDENCIAS
</div>

<br>

Para instalar as dependencias do projeto, basta executar o comando abaixo em seu terminal na **pasta do projeto**.

```
bundle install
```

<br>

<div align='center'>
  
  # CONFIGURAÇÕES
</div>

<br>

No arquivo **.env** na raiz de seu projeto coloque o seguinte valor

```
API_URL=https://pokeapi.co/api/
```

<br>

A Variavel de ambiente **API_URL** é necessária para termos o ponto base da URL que utilizaremos
da API do **PokéAPI** quando quisermos consultar os dados dos pokemons lá cadastrados, para montar
a nossa resposta.

<br>

Após adicionar a env basta subir o servidor utilizando o comando abaixo:

```
  rails server -p 3000
```

<div align='center'>

  # DOCKER
</div>

<br>

Você pode executar esse projeto através do docker, é simples e prático, basta executas os comandos abaixo
na pasta raiz do projeto, a mesma onde se encontram os arquivos **Dockerfile** e **docker-compose.yml**

<br>

![Captura de tela de 2023-09-21 16-05-17](https://github.com/RenatoRosaFranco/pokeapi-challenge/assets/6882872/b5db9ce9-4702-4d59-83f4-811e174b02f6)


<br>

```
  docker-compose build --no-cache # make the build
  docker-compose up               # Initialize containers
  docker-compose down             # Remove containers
```


<div align='center'>

  # TESTES
</div>

<br>

Você pode rodar os testes automatizados apartir da pasta raiz do projeto utilizando o comando abaixo.

```
bundle exec rspec /spec/interactors/
bundle exec rspec /spec/requests/
bundle exec rspec /spec/
```

<br>

![Captura de tela de 2023-09-22 00-49-36](https://github.com/RenatoRosaFranco/pokeapi-challenge/assets/6882872/18ab7b37-b5f5-4088-bce6-47f30df155e8)


<br>

<div align='center'>
  
  # CACHING
</div>

<br>

A API tem um caching operando na endpoint /pokemons, onde o usuário so fara a requisição apenas uma vez
para um dado pokemon, sendo este resultado armazenado no Cache, se o usuário tentar requisitar informações
do mesmo pokemon novamente, a API não terá necessidade de realizar outra requisição, poderá utilizar os
dados da requisição prévia, já armazenada.

<br>

Módulo responsavel por implementar o cache na aplicação

<br>

```
# frozen_string_literal: true

module Http
  module Cache
    class CacheService
      attr_reader :logger, :cache

      def initialize(logger, cache)
        @logger = logger
        @cache  = cache
      end

      def generate(suffix, name)
        "#{suffix}_#{name}"
      end

      def read(cache_key)
        logger.level = Logger::INFO
        logger.write(:info, "Cache key #{cache_key} readed")
        cache.read(cache_key)
      rescue StandardError => e
        logger.level = Logger::ERROR
        logger.write(:error, "Failed to read cache key #{cache_key}")
      end

      def write(cache_key, serialized_object, expiration = 1.minute)
        logger.level = Logger::INFO
        logger.write(:info, "Cache Key create for #{cache_key}")
        cache.write(cache_key, serialized_object, expires_in: expiration)
      rescue StandardError => e
        logger.level = Logger::ERROR
        logger.write(:error, "Failed to write cache key #{cache_key}")
      end
    end
  end
end
```

<br>

**OBS**: Para ver o cache em pleno funcionamento no ambiente de desenvolvimento basta executar o comando
abaixo antes de rodar o servidor:

<br>

```
  bin/rails dev:cache # Development mode is now being cached.
```

Para desativar o Cache basta executar o comando novamente e o console irá te retornar o seguinte resultado:

```
 bin/rails dev:cache # Development mode is no longer being cached.
```

<br>

![Captura de tela de 2023-09-22 00-41-29](https://github.com/RenatoRosaFranco/pokeapi-challenge/assets/6882872/68f02916-8892-451f-adc1-3945ab5afefb)



