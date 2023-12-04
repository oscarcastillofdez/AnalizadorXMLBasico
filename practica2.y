%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#define MAX_STRING 200
extern int yylex();
void yyerror (char const *);
extern int line;

%}

%union{
    char val[200];
}

%token START_DEC END_DEC CLOSE_TAG EARLY_END 
%token VER_VAL IGUAL ESP CARACTER_ESP
%token START_COM END_COM ERROR END_COM_BAD CONTENT 
%token <val> WORD INIT_TAG END_TAG ENC_VAL
%type xml_dec xml_cont xml_cont2 tag tag_cont comment xml_dec_list comment_list
%type <val> init_tag end_tag 
%start S

%%

S : xml_dec_list xml_cont
  | xml_cont {
    char error[MAX_STRING] = "Declarecion cabecera no detectada";
    line = 1;
    yyerror(error);
  }

xml_dec_list : xml_dec
             | xml_dec_list xml_dec {
              yyerror("Cabecera encontrada en lugar inadecuado");
             }

xml_dec : START_DEC WORD IGUAL VER_VAL WORD IGUAL ENC_VAL END_DEC {
          if (strcmp($2, "version") != 0) {
            char error[MAX_STRING] = "Encontrado: ";
            strcat(error, $2);
            strcat(error, " y se esperaba ");
            strcat(error, "version");
            yyerror(error);

          } else if (strcmp($5, "encoding") != 0) {
            char error[MAX_STRING] = "Encontrado: ";
            strcat(error, $5);
            strcat(error, " y se esperaba ");
            strcat(error, "encoding");
            yyerror(error);
          }
        }
        | START_DEC WORD IGUAL VER_VAL END_DEC {
          if (strcmp($2, "version") != 0) {
            char error[MAX_STRING] = "Encontrado: ";
            strcat(error, $2);
            strcat(error, ">” y se esperaba ");
            strcat(error, "version");
            yyerror(error);
          }
        }

xml_cont : xml_cont2 comment_list
         | xml_cont2
         | xml_cont2 comment_list tag {
          yyerror("Encontrada mas de una etiqueta raiz");
         }

xml_cont2 : comment_list tag
          | tag

comment_list : comment_list comment
             | comment

tag : INIT_TAG EARLY_END
    | init_tag end_tag{
        if (strcmp($1,$2)!= 0) {
          char error[MAX_STRING] = "Encontrado \"</";
          strcat(error, $2);
          strcat(error, ">\" y se esperaba \"</");
          strcat(error, $1);
          strcat(error, ">\"");
          yyerror(error);
        }
      }
    | init_tag tag_cont end_tag{
        if (strcmp($1,$3)!= 0) {
          char error[MAX_STRING] = "Encontrado \"</";
          strcat(error, $3);
          strcat(error, ">\" y se esperaba \"</");
          strcat(error, $1);
          strcat(error, ">\"");
          yyerror(error);
        }
      }

tag_cont : tag_cont CONTENT
         | tag_cont tag
         | tag_cont comment
         | CONTENT
         | tag
         | comment
         | tag_cont xml_dec {
          yyerror("Cabecera encontrada en lugar inadecuado");
         }
         | xml_dec {
          yyerror("Cabecera encontrada en lugar inadecuado");
         }

comment : START_COM END_COM
        | START_COM error_list END_COM{
          yyerror("Comentario mal formado. \"--\" no aceptado");
        }
        | START_COM error_list END_COM_BAD{
          yyerror("Comentario mal formado. \"--->\" no aceptado");
        }
        | START_COM END_COM_BAD{
          yyerror("Comentario mal formado. \"--->\" no aceptado");
        }

error_list : error_list ERROR
           | ERROR

init_tag : INIT_TAG CLOSE_TAG{
           strcpy($$,$1);
           }

end_tag : END_TAG CLOSE_TAG{
          strcpy($$,$1);
          }

%%

int main() {
    yyparse();
    printf("Sintaxis XML correcta.\n");
    return 0;
}

void yyerror (char const *s) {
  fprintf(stderr, "Error en linea %d: %s \n",line, s);
  exit(0);
}
