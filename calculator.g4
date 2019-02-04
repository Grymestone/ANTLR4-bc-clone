grammar calculator; 

@header {
import java.util.*;
}

@parser::members
{
/** "memory" for our calculator; variable/value pairs go here */
Map<String, Integer> memory = new HashMap<String, Integer>();

int eval(int l, int op, int r)
	{ switch(op) 
		{ case MULT: return l * r;
		case DIV: return l / r;
		case ADD: return l + r;
		case SUB: return l - r;
		}
	return 0;
	}
}

exprList: topExpr (';' topExpr)*';'?;

topExpr: expr
  { System.out.println("result: "+ Integer.toString($expr.i));};

expr returns [int i]:
    er = expr op = (MULT | '/') el = expr 
    	{$i = eval($er.i, $op.type, $el.i);
	System.out.println($i);}
    | er = expr op = ('+' | '-') el = expr
    	{$i = eval($er.i, $op.type, $el.i);
	System.out.println($i);}
    | INT
        { $i=Integer.parseInt($INT.text);} 
    | ID EQUAL INT
    	{
	  String id = $ID.text;
	  memory.put(id, Integer.parseInt($INT.text));
	  System.out.println(memory.get(id));
	}
    | ID
    	{ String id = $ID.text;
	$i = memory.containsKey(id) ? memory.get(id) : 0;
	System.out.println(id);}
    | '(' e=expr ')'	          
    ;

ID: [_A-Za-z]+ ;
EQUAL: '=';
INT: [0-9]+ ;		      
MULT: '*' ;
SUB: '-';
DIV: '/';
ADD: '+';
WS: [ \t\r\n]+ -> skip ;
