## Função de conexão a um BD Oracle 8i em Pro*C

Obs.: O código abaixo foi extraído de um programa que criei.
Não será possível postar todo o código por questões legais de confidencialidade empresarial.
A extensão do arquivo deve ser .pc

### Programa Principal em Pro*C 
```

# Bibliotecas

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <sqlca.h>
#include <sqlcpr.h>
#include <time.h>
#include <unistd.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <ctype.h>
#include <libgen.h>
#include <signal.h>
#include <dirent.h>    
#include <stdarg.h>
#include <malloc.h>

# Definição das constantes 
#define USER                        "nome_usuario_bd"   /* usuário do banco de dados */
#define SENHA                       "senha_do_bd"       /* senha do banco de dados */
#define NOME_BD                     "nome_do_bd"        /* Nome do Banco de Dados */
#define RET_SUCESSO                 0                   /* codigo de retorno      */
#define RET_ERRO                    1                   /* codigo de retorno      */
#define FALSE                       0
#define TRUE                        !FALSE

EXEC ORACLE OPTION (ORACA=YES);
EXEC ORACLE OPTION (MAXOPENCURSORS=20);

EXEC SQL BEGIN DECLARE SECTION;

EXEC SQL END DECLARE SECTION;

/* Prototipos de funcoes */
int  fConectaDatabase(char *szDatabase, char *szUsername, char* szSenha);
void fSqlError(struct sqlca * sqlca, char *fmt, ...);

/* variáveis Globais */
int  giSqlError;

void main(int argc, char **argv  )
{
  char szNomeServ[31];
  int iErro = FALSE;
  char szFullLogName[1024] ;      /* nom e path do arquivo de log */  
  
  iErro = fConectaDatabase(NOME_BD, USER, SENHA);
  
   if(iErro)
   {
      exit(RET_ERRO);
   }
   else
   {
      exit(RET_SUCESSO);
   }  
  
 }
```

### Função fConectaDatabase 
```
int fConectaDatabase(char *szDatabase, char *szUsername, char *szSenha) 
{
   int iErro = FALSE;
   EXEC SQL BEGIN DECLARE SECTION;
   VARCHAR  vcPassword[PASSWORD_LEN];
   VARCHAR  vcDbString[128];
   VARCHAR  vcUsername[USERNAME_LEN];
   EXEC SQL END DECLARE SECTION;   
   
   printf("Conectando a base de dados...");
   strcpy ( (char *)(vcUsername.arr), szUsername);
   vcUsername.len = (unsigned short)strlen((char *) vcUsername.arr);
   strcpy ( (char *)(vcUsername.arr), szSenha);
   vcPassword.len = (unsigned short)strlen((char *) vcPassword.arr);
   strcpy( (char *)(vcDbString.arr), szDatabase);
   vcDbString.len = (unsigned short)strlen((char *) vcDbString.arr);      
    
   EXEC SQL WHENEVER SQLERROR DO fSqlError(&sqlca, 
            "Conectando ao banco de dados");                  
        
   EXEC SQL CONNECT :vcUsername IDENTIFIED BY :vcPassword AT :szDatabase USING :vcDbString;      
    
    if(giSqlError)      
       iErro = TRUE;                  
      
   if (!iErro) 
      printf("Erro ao conectar a base de dados ");
   else
     printf("Conexao realizada com sucesso");
     
   return iErro;
}/*fConectaDatabase */
```

### Funcao: fSqlError() - Reconhece e registra erros ORACLE
```
/**************************************************************************
** Funcao          : fSqlError()
** Descricao       : Reconhece e registra erros ORACLE 
** Parametros      : struct sqlca sqlca, char * msg
** Valor Retorno   : Nenhum
******************************************************************************/
void fSqlError(struct sqlca * sqlca, char *fmt, ...)
{
   va_list ap;
   char szMsg[1024];
   char ErroOracle[1024];
   
   EXEC SQL WHENEVER SQLERROR CONTINUE;
   giSqlError = TRUE;
   
   va_start (ap, fmt);
   vsprintf (szMsg, fmt, ap);
   sprintf(ErroOracle, "%s - %s - %s",
           szMsg,
           sqlca->sqlerrm.sqlerrml,
           sqlca->sqlerrm.sqlerrmc);
   printf(ErroOracle);           
   EXEC SQL ROLLBACK;
} /*fSqlError */
```
