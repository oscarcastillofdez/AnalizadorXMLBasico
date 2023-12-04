
%{
  #include "practica2.tab.h"
  int line = 1;
%}

%start INIT
%start COMMENTL
%start DEC
%start TAG

esp [ \t]+

start_dec <"?"xml" "
end_dec "?">

ver_val [0-9]"."[0-9]
word [^="'<>?\n\t ]+

start_com <"!""-""-"
end_com "-""-">

open_tag <[A-Za-z_][^ "\n:/<>\t\n?=]*
end_tag <"/"[A-Za-z_][^ "\n:/<>\t\n?=]*
close_tag >
early_end "/">

%%

{start_dec} {BEGIN DEC;return START_DEC;}
<DEC>{end_dec} {BEGIN INIT; return END_DEC;}
<DEC>[']{ver_val}['] {return VER_VAL;}
<DEC>[']{word}['] {strcpy(yylval.val,yytext);return ENC_VAL;}
<DEC>["]{ver_val}["] {return VER_VAL;}
<DEC>["]{word}["] {strcpy(yylval.val,yytext);return ENC_VAL;}
<DEC>= {return IGUAL;}
<DEC>{word} {strcpy(yylval.val,yytext);return WORD;}

{start_com} {BEGIN COMMENTL; return START_COM;}
<COMMENTL>"-""-" {return ERROR;}
<COMMENTL>[^\n] {}
<COMMENTL>{end_com} {BEGIN INIT; return END_COM;}
<COMMENTL>-{end_com} {BEGIN INIT; return END_COM_BAD;}

<INIT>[^\n\t <]+ {return CONTENT;}

{open_tag} {BEGIN TAG; int len = strlen(yytext);char buffer[len]; memmove(buffer, yytext+1, len);strcpy(yylval.val,buffer);return INIT_TAG;}
{end_tag} {BEGIN TAG; int len = strlen(yytext); char buffer[len]; memmove(buffer, yytext+2, len);strcpy(yylval.val,buffer);return END_TAG;}
<TAG>{close_tag} {BEGIN INIT; return CLOSE_TAG;}
<TAG>{early_end} {BEGIN INIT; return EARLY_END;}

{esp} {}
\n {line++;}
. {return CONTENT;}
%%


