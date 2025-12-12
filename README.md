# Aprendendo Terraform

Este repositório tem o objetivo de auxiliar nos estudos da ferramenta desenvolvida mais famosa pela HashiCorp de IaC, o Terraform.

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

### Após configurar os dois arquivos mínimos, chegou a hora de usar os comandos para executar o Terraform

1. Providers
    Indica quais são os providers que estão mencionados no código e que serão necessários para que o código rode corretamente.

    ```bash
    terraform providers
    ```

2. Init
    É obrigatório fazer toda vez que voê está usando uma configuração em um diretório pela primeira vez, ou quando faz alguma alteração no provider ou no módulo.
    ```bash
    terraform init
    ```
    ![tf_init](https://github.com/polianaraujo/learning-terraform/blob/main/images/tf_init.png)