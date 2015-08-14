%option nounput
%option noinput

%{
#define MAX_STRING_LENGTH 1024
#include "message.h"
#define YYSTYPE char*
#include "parser.tab.h"
%}

%x string

%%
	char string_buf[MAX_STRING_LENGTH];
	char *string_buf_ptr;
     
[ \t\n] ;

\" { /* Begin of a string */
  string_buf_ptr = string_buf; BEGIN(string);
}

<string>\" { /* End of a string */
  BEGIN(INITIAL);
  *string_buf_ptr = '\0';
  yylval = strdup(string_buf);
  return STRING;
}
     
<string>\n {
  syntax_error ("unterminated string constant");
  BEGIN(INITIAL);
}
     
<string>\\[0-7]{1,3} {
  /* octal escape sequence */
  int result;

  (void) sscanf( yytext + 1, "%o", &result );

  if ( result > 0xff ) {
    syntax_error ("constant is out-of-bounds");
		BEGIN(INITIAL);
  } else {
    *string_buf_ptr++ = result;
  }
}
     
<string>\\[0-9]+ {
  syntax_error ("bad escape sequence");
  BEGIN(INITIAL);
}
     
<string>\\n  *string_buf_ptr++ = '\n';
<string>\\t  *string_buf_ptr++ = '\t';
<string>\\r  *string_buf_ptr++ = '\r';
<string>\\b  *string_buf_ptr++ = '\b';
<string>\\f  *string_buf_ptr++ = '\f';
     
<string>\\(.|\n)  *string_buf_ptr++ = yytext[1];
     
<string>[^\\\n\"]+ {
  char *yptr = yytext;

  while ( *yptr )
    *string_buf_ptr++ = *yptr++;
}

[0-9]+\.[0-9]+ { /* Floating point number */
    yylval = strdup(yytext);
    return FLOAT;
}

[0-9]+ { /* Exact number */
    yylval = strdup(yytext);
    return EXACT;
}

"(" { return '('; }
")" { return ')'; }

[a-zA-Z0-9_*!$%&/=?<>+*,.:_-]+ { /* Symbol */
    yylval = strdup(yytext);
    return SYMBOL;
}

%%
