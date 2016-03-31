%{
	#include "ext.h"
//	enum bool{false, true};
	
	char alphabet[1000];
	struct transition transitions[1000];
	struct state states[1000];
	struct state x;
	struct transition y;
	int contState = 0;
	int contTransition = 0; 
	extern int yylex();
	extern void yyerror(const char* s);
//	extern "C" int yyparse (void);
	
%}
%union{
	int number;
	char *string;
	bool boolean;
	//char* name;
	//int id, to, from;
	//bool isFinal, isInitial;
	// char character;
}

%token FINAL NAME ID INIT NUM ALPHA ftr
%type<string> startName ALPHA ftr transition
/*%type<boolean>ruleInit*/
%type<number> startCond NUM
/*%type<id> startCond
%type<name> startName 
%type<to> transition
%type<sigma> transitionRead*/
%%
begin:  startCond | startCond ruleInit ruleFinal | startCond ruleInit | startCond ruleFinal 
		| begin closeState
		;
seeTransitions	: 	seeTransitions transition 
			| 	transition
			;
closeState		: 	"</state>"
			| 	"</state>" seeTransitions  {states[contState] = x; resetState();};

startCond		:	ID '=' '"' NUM startName {x.id = $4;}
startName		:	NAME '=' '"' ALPHA {x.name = $4;}
ruleInit		: 	INIT {x.isInitial = true;}
ruleFinal		:	FINAL {x.isFinal = true;}
transition		: 	ftr ALPHA {fromToRead($1, $2);}
			| 	"</transition>" {transitions[contTransition] = y; contTransition++;}
			;

%%
#include <stdarg.h>
void ERROR(const char* fmt, ...) {
	va_list ap;
	va_start(ap, fmt);
	vfprintf(stderr, fmt, ap);
	va_end(ap);
}

void yyerror(const char* msg){
	ERROR ("Error: %s\n", msg);
}
void fromToRead(char* ftr, char * str){
	if(strcmp(ftr, "<from>") == 0)
		y.from = atoi(str);
	else if(strcmp(ftr,"<to>") == 0)
		y.to = atoi(str);
	else
		y.sigma = str;
}
void resetState(){
	x.isFinal = false;
	x.isInitial = false;
	contState++;
}
int main(){
	yyparse();
	printf("QUINTUPLO\n");
	printf("ESTADOS = { ");
	int init = 0;
	for (int i = 0; i < contState; i++){
		printf("%s, ", states[i].name);
		if(states[i].isInitial) init = i;
	}
	printf("}\n");

	printf("INICIAL = %s\n", states[init].name);
	printf("FINALES = { ");
	for(int i = 0; i< contState; i++){
		if(states[i].isFinal == 1)
			printf("%s, ", states[i].name);
	}
	printf("}\n");

}

/* C code goes here */
