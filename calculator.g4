grammar calculator; 

@header {
import java.util.*;
import java.lang.Math;
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

topExpr: stat+ ;
  //{ System.out.println("result: "+ Integer.toString($expr.i));};

stat: expr NEWLINE
    {
          System.out.println($expr.i);
    }
    | ID '=' expr NEWLINE
        {
	  String id = $ID.text;
          memory.put(id, $expr.i);
	}
    | NEWLINE

;

expr returns [int i]:
    er = expr op = (MULT | '/') el = expr 
    	{$i = eval($er.i, $op.type, $el.i);}
    | er = expr op = ('+' | '-') el = expr
    	{$i = eval($er.i, $op.type, $el.i);}
    | INT
        { $i=Integer.parseInt($INT.text);} 
    | ID
    	{ String id = $ID.text;
	$i = memory.containsKey(id) ? memory.get(id) : 0;
	}
    | 'sqrt(' e=expr ')' {
       $i = (int)Math.sqrt($e.i); 
    }
    | 'read()' NEWLINE INT {
        $i=Integer.parseInt($INT.text);
    }

    | '(' e=expr ')'	          
    ;

ID: [_A-Za-z]+ ;
EQUAL: '=';
INT: [0-9]+ ;		      
MULT: '*' ;
SUB: '-';
DIV: '/';
ADD: '+';
NEWLINE:'\r'? '\n' ;
WS: [ \t]+ -> skip ;

