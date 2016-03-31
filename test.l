%{
	//#include "<string.h>"
//	extern "C" int yylex();
	#include "ext.h"
	#include "ext.tab.h"
	//#define true 1
	//#define false 0
	//enum{STATE=1,INIT, FINAL, IDENTIFIER};
	/*
	struct tell{
		int id, isInitial, isFinal;
		char * name;
	};*/
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
<STATE>{NUMBER}						{yylval.number = atoi(yytext); return NUM;} /* rule for state id */
<STATE>{ALPHA}+						{yylval.string = yytext; return ALPHA;} /* rule for state name */
<STATE>"<intial/>"					{yylval.boolean = true; return INIT;}
<STATE>"<final/>"					{yylval.boolean = true; return FINAL;}
<STATE>"</state>"					BEGIN INITIAL;
"<transition>"						BEGIN TRANSITION;
<TRANSITION>"<from>"|"<to>"|"<read>"			{yylval.string = yytext; return ftr;}
<TRANSITION>{NUMBER}					{yylval.number = atoi(yytext); return NUM;} /* rule for state id */
<TRANSITION>{ALPHA}+					{yylval.string = yytext; return ALPHA;} /* rule for transition read */

"</transition>"				BEGIN INITIAL;
[=\"]					{return yytext[0];}
"id"					{return ID;}
"name"					{return NAME;}
.					{printf("%s", yytext);}

%%
