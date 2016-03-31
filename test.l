%{
	//#include "<string.h>"
	#include "ext.tab.h"
	#include <stdio.h>
	#define true 1
	#define false 0
	//enum{STATE=1,INIT, FINAL, IDENTIFIER};
	struct tell{
		int id, isInitial, isFinal;
		char * name;
	};
	//struct tell yylval;
	//extern yylval;
%}
%s STATE
%s TRANSITION
%option noyywrap
ALPHA [a-zA-Z0-9]
DIGIT [0-9]
NUMBER {DIGIT}+
%%

"<state" 								BEGIN STATE;
&#13;									;
<STATE>{NUMBER}							{yylval.id = atoi(yytext); return IDENTIFIER;} /* rule for state id */
<STATE>{ALPHA}+							{yylval.name = yytext; return IDENTIFIER2;} /* rule for state name */
<STATE>"<intial/>"						{yylval.isInitial = true; return INIT;}
<STATE>"<final/>"						{yylval.isFinal = true; return FINAL;}
<STATE>"</state>"						BEGIN INITIAL;
"<transition>"							BEGIN TRANSITION;
<TRANSITION>"<from>"|"<to>"|"<read>"	{return yytext;}
<TRANSITION>{NUMBER}					{yylval.id = atoi(yytext); return IDENTIFIER3;} /* rule for state id */
<TRANSITION>{ALPHA}+					{yylval.name = yytext; return IDENTIFIER4;} /* rule for transition read */

"</transition>"				BEGIN INITIAL;
[=\"]						{return yytext[0];}
id|name						{printf("%s", yytext); /*return yytext;*/}
.							{printf("%s", yytext);}

%%
