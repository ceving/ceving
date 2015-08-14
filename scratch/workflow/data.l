%option nounput
%option noinput

%{
#define MAX_STRING_LENGTH 1024
#include "syntax_error.h"
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
  printf ("Found a string: '%s'\n", string_buf);
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
  printf ("Found a floating-point number: '%s'\n", yytext);
}

[0-9]+ { /* Integer */
  printf ("Found an integer: '%s'\n", yytext);
}

[a-zA-Z0-9_*!$%&/=?<>+*,.:_-]+ { /* Symbol */
  printf ("Found a symbol: '%s'\n",  yytext);
}

%%

int main (int argc, char** argv) {
  yylex();
  return 0;
}
