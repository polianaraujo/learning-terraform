# Aprendendo Terraform

Este repositório tem o objetivo de auxiliar nos estudos da ferramenta mais famosa desenvolvida pela HashiCorp de IaC, o Terraform.

Ele permite criar e gerenciar infraestrutura (servidores, bancos de dados, etc) usando código (IaC). Em vez de clicar manualmente no console AWS, basta escrever um arquivo de configuração e o Terraform consegue criar tudo.

- A lógica
    - Ele usa abordagem declarativa: Você diz o que ele deve fazer, e ele faz ao executar o script.
    > Nota: Diferente de outros scripts tradicionais, ele verifica se já existe antes de criar mais uma vez. Por exemplo, ao criar um servidor igual, se já existir ele não cria novamente. Isso é feito graças ao `terraform.tfstate` que funciona como a memória dele, anotando tudo o que já foi criado, e portanto, se for excluído, ele pode realizar duplicação ou perder controle sobre os recursos.
- Fluxo de trabalho
    - Escrita: Código em arquivos `.tf` usando linguagem HCL - HashiCorp Configuration Language.
    - Planeja: Ao rodar `terraform plan`, ele vai comparar o código com o que já existe na nuvem e mostra um preview do que ele vai fazer (o que será criado, alterado ou destruído).
    - Aplica: Ao rodar `terraform apply`, ele vai executar as chamadas de API necessárias para criar a infraestrutura real.

- Providers: O Terraform não sabe como falar com a AWS ou Azure. Ele usa pluguins (providers), e existe para quase tudo, como AWS, Docker, Kubernets, Spotify, Snowflake, etc.

## Por quê ele é importante e exigido pelo mercado?

- Multi-cloud: Você pode usar a mesma ferramenta e linguagem para gerenciar AWS, Azure e Google Cloud no mesmo projeto.

- Versionamento: Como sua infraestrutura agora é código, você pode salvá-la no Git. Isso permite que você tenha um histórico de quem alterou o quê e quando (exatamente como desenvolvedores fazem com software).

- Automação e Velocidade: Você pode subir um ambiente inteiro de produção em minutos, em vez de dias.


## Instalando extenções (opcional, mas recomendado)

- HashiCorp Terraform
- HashiCorp HCL


## Estrutura de arquivos

- `main.tf`: 
- `bucket.tf`:

## Após configurar os dois arquivos mínimos, chegou a hora de usar os comandos para executar o Terraform

1. Providers
    Indica quais são os providers que estão mencionados no código e que serão necessários para que o código rode corretamente.

    ```bash
    terraform providers
    ```

2. Init
    É obrigatório fazer toda vez que você está usando uma configuração em um diretório pela primeira vez, ou quando faz alguma alteração no provider ou no módulo.
    ```bash
    terraform init
    ```
    ![tf_init](https://github.com/polianaraujo/learning-terraform/blob/main/images/tf_init.png)

    Esse comando gera automaticamente:

    - `terraform-provider-<PROVEDOR_DE_CLOUD>_v<VERSAO_PROVIDER>` Arquivo de configuração do provider: 
    - `.terraform.lock.hcl` (Dependency Lock): Com esse arquivo, o Terraform vai saber se você fez alguma alteração na versão do provider ou se adicionou algum provider novo.

3. Formatar o código automaticamente
    
    Este comando (b) formata o código automaticamente para melhor legibilidade.

    Antes de executar o comando (b), o comando (a) vai listar quais arquivos é necessário fazer uma mudança.

    Já o comando (c), executa a formatação ao mesmo tempo que mostra o que foi alterado pelo terminal.

    ```bash
    terraform fmt -check    # (a)
    
    terraform fmt           # (b)

    terraform fmt -diff     # (c)
    ```

4. Validação do código
    Este comando vai verificar se o código é válido ou não.

    ```bash
    terraform validate
    ```

## Após isso, executar as credenciais `AWS_ACCESS_KEY_ID` e `AWS_SECRET_ACCESS_KEY` no terminal no formato do arquivo para o seu sistema (Windows, Linux, etc).

Após isso,

1. Plano
    ```bash
    `terraform plan`
    ```

    Expõe um plano do que o terraform pretende fazer no terminal, sem fazer qualquer alteração.
    E nesse caso, ele pretende criar um recurso de `aws_s3_bucket` com as configurações listadas.

    > Extra: `terraform plan -out <NOME_DO_ARQUIVO>.out` para salvar o plano de ação dentro de um arquivo. Isto gera um arquivo binário, que pode ser visto através do comando `terraform show <NOME_DO_ARQUIVO>.out`.

    Para criar um plano de destruição de configuração,

    ```bash
    # Criar o plano de destruição
    `terraform plan -out plan.out -destroy`

    # Executar plano de destruição
    `terraform apply plan.out`
    ```

2. Para construir
    ```bash
    `terraform apply`
    ```

    Para executar o `apply` novamente, é necessário executar `terraform apply -destroy`.

    Outro comando é o `terraform apply -auto-approve`: ele mostra o plano e o executa, sem perguntar para confirmar se você quer que seja ou não executado. (Não recomendado)

- Após o primeiro `apply`, é criado o arquivo:
    - `terraform.tfstate`: Mapeamento de todos os recursos definidos no código para os objetos reais que existem na nuvem utilizada.
    - `terraform.tfstate.backup`: A última versão antes da presente em `terraform.tfstate`.

## `locals.tf` e `variables.tf`

- `locals.tf`
    Serve para definir valores locais (valores temporários ou auxiliares), auxiliando na reutilização de código. São calculados internamente dentro do código, diferentemente de `variables.tf` que aceitam valores externos.

    Como o bloco `locals` serve para guardar diferentes valores locais, então, para chamar algum deles em outro código utiliza-se `local.name`, `local.tags`, etc.

- `variables.tf`
    Permite customizar a infraestrutura sem alterar o código fonte, aceitando valores externos (do usuário ou de outro módulo).
    - Definem o tipo de dado esperado (string, number, bool...)
    - Definindo a variável como `default`, ela se torna opcional. Portanto, se não for `default`, o Terraform vai pedir um valor na execução para essa variável.

    Chamada: `var.name`, `var.enviroment`, etc.

### Diferença entre os dois

|Característica|`locals.tf`|`variables.tf`|
|-|-|-|
|Conceito|Lógica interna/Processamento|Interface Pública/Entrada de dados|
|Origem|São calculados dentro do módulo|Vêm de fora do módulo (usuário, CLI, arquivo.tfvars)|
|Flexibilidade|O usuário não pode alterar diretamente*, é lógico interna fixa|O usuário pode alterar o valor ao rodar o `plan`|
|Analogia|Variáveis declaradas dentro da função|Parâmetros de uma função|

* "Alterar diretamente" significa passar um valor de fora para dentro no momento em que você roda o comando.
    Com `variables` pode rodar `terraform apply -var="ambiente-prod"`, e o Terraform irá aceitar esse valor externo e o injeta na variável.
    Com `locals` não é possível, pois não existe um comando como `terraform apply -local="nome=joao"`. O valor do `local` está trancado dentro da lógica do seu script.


### Existe uma ordem de precedência para definir nomes

1. `variables.tf`
2. Criar e executar variável no terminal. `export <nome-da-variavel-que-quer-alterar-valor>=<valor>`
3. `terraform.tfvars`
4. `variables.auto.tfvars`
5. Definir variável no terminal no momento de executar o `terraform plan -out plan.out -var <nome-variavel>="<valor>"`.
6. Criar um arquivo (exemplo: `var`) e executar no terminal: `terraform plan -out plan.out -var <nome-variavel>="<valor> -var-file=var"`.
    ```
    container_name = "container-var-file-cli"
    ```

## Outputs
Serve para pegarmos alguma informação produzida pelo código do Terraform, e serve para nós colocarmos para fora do código para ser usado em outro momento.

Resumindo, é para expor informações sobre a infraestrutura na linha de comando, no Terraform do HCP e em outras configurações do Terraform.

Pode ser usado na linha de comando por algum outro programa ou pode ser usado por algum outro código do Terraform, ou opde ser usado em módulos.

## Remote State

Já foi mencionado que o `.tfstate` gerado é apenas local e gera somente o bucket do último state antes do atual. Então, isso é funciona bem para projetos pessoais.

Essa situação em projetos colaborativos não funcionaria muito bem, pois cada usuário precisa garantir que tenha os dados de estado mais recente antes de executar o Terraform e que ninguém mais o execute simultaneamente.

Por isso, seria interessante ter um histórico armazenado remotamente dos diferentes states já realizados, e é por isso que existe o Remote State:

- **Colaboração em equipe:** Toda a equipe consegue consultar as versões que estarão armazenadas no Backend Remoto.

- **State locking:** Impede execuções simultâneas no mesmo estado, travando o arquivo enquanto uma pessoa estiver manipulando.

- **Segurança e dados sensíveis:** Diferente do `.tfstate` local, no remoto é possível gerenciar permissões de cacsso, criptografia e versionamento.

- **Isolamento e referência entre projetos:** `terraform_remote_state` permite que um projeto Terraform leia saídas (outputs) de outro projeto.

### Criar uma VPC (Virtual Private Cloud) na AWS com Remote State

- VPC (Infraestrutura): É um datacenter virtual dentro da AWS, permitindo criar uma rede isolada logicamente, onde se tem controle total sobre o ambiente, desde o endereçamento IP até as regras de segurança. É a rede virtual onde você lança os recursos AWS de forma isolada e segura.

- Remote State (Gestão): Ao usar Terraform para criar a VPC, é gerado o arquivo `.tfstate`, e usar o Remote State significa armazenar esse arquivo em um serviço como a S3.

## Remote State Data Source

Serve para acessar um Remote State de um outro código do Terraform, só que ele não acesso o state por completo, apenas os outputs.

## Comandos `terraform show / state`

### `terraform state`

Possui uma lista de subcomandos:

- `terraform state list`: Lista quais recursos estão no state.
- `terraform state mv <nome_antigo_do_recurso> <nome_novo_do_recurso>`: Atualizar nome de recursos, sem destruir e criar um novo (sem precisar fazer `plan`).
- `terraform refresh`: Atualiza o estado local com o que existe na nuvem (útil se alguém mudou algo manualmente no console da AWS/Azure).


## Bloco `removed{}`

Serve para remover um recurso, e pra usá-lo é necessário apagar o recurso definido no código.

O `lifecycle{}`, no exemplo abaixo, serve para impedir a destruição do recurso aws_s3_bucket.bucket_3, apagando somente o controle dele do state do Terraform. Com isso, o recurso continua existindo na nuvem, mas o Terraform deixa de gerenciá-lo.

```tf
resource "aws_s3_bucket" "bucket_3" {
    bucket = "poliana_bucket"
}

removed {
    from = aws_s3_bucket.bucket_3

    lifecycle {
        destroy = false
    }
}
```


## Provisioners

São usados para automação de tarefas pós-criação ou pré-destruição de recursos, mas seu uso deve ser limitado, pois o ideal é que a infraestrutura seja totalmente declarativa.

```tf
resource "aws_instance" "example" {
  # ...configuração...

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nginx"
    ]
  }
}
```

### Criação de VM com provisioners

