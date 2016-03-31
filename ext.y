%{
	#include <stdio.h>
	struct state{
		int isFinal, isInitial;
		char *name;
		int id;
	};
	struct transition{
		int to, from;
		char sigma;
	};
	char * alphabet[];	
	struct transition transitions[1000];
	struct state states[1000];
	struct state x;
	struct transition y;
	int contState = 0;
	int contTransition = 0;  
	extern int yylex();
	extern void yyerror(const char* s);
%}
%union{
	char* name;
	int id, to, from;
	int isFinal, isInitial;
	char sigma;	
}
%token INIT 
%token FINAL 
%token IDENTIFIER
%token IDENTIFIER2
%token IDENTIFIER3
%token IDENTIFIER4
%type<id> IDENTIFIER
%type<name> IDENTIFIER2
%type<to> IDENTIFIER3
%type<sigma>  IDENTIFIER4
%type<id> startCond
%type<name> startName 
%type<to> transition
%type<sigma> transitionRead
%%

begin:  startCond | startCond ruleInit ruleFinal | startCond ruleInit | startCond ruleFinal 
		| begin closeState
		;
seeTransitions: seeTransitions transition | transition	;
closeState: "</state>"| "</state>" seeTransitions  {states[contState] = x; x.isFinal = 0; x.isInitial = 0; contState++;};
startCond:		"id" '=' '"' IDENTIFIER startName {x.id = $4;}
startName: 		"name" '=' '"' IDENTIFIER2 {x.name = $4;}
ruleInit: 			INIT {x.isInitial = 1;}
ruleFinal:			FINAL {x.isFinal = 1;}
transition: 	"<from>" IDENTIFIER3 {y.from = $2;}
				| "<to>" IDENTIFIER3 transitionRead {y.to = $2;}
				| "</transition>" {transitions[contTransition] = y; contTransition++;}
				;
transitionRead: "<read>" IDENTIFIER4 {y.sigma = $2;} 	

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
