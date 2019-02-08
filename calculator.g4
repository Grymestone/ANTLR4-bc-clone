grammar calculator; 

@header {
import java.util.*;
import java.lang.Math;
import java.util.Scanner;
}

@parser::members
{
Map<String, Double> vars = new HashMap<String, Double>();

double beval(Boolean neg, double l, String op, double r)
{ 
	if (op.equals("||"))
	{	
		if (((l > 0) || (r > 0)) && !neg)
		{
			return 1;
		}
		else
		{
			return 0;
		}
	}
	else if (op.equals("&&"))
	{
		if (((l > 0) && (r > 0)) &&  !neg)
		{
			return 1;
		}
		else
		{
			return 0;
		}
	}
	else
	{
		System.out.println("Bad logic operator.");
		return 0;
	}
}

double eval(double l, int op, double r)
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

topExpr: printstat
    |stat+ ;
  //{ System.out.println("result: "+ Integer.toString($expr.i));};

stat: 
    '/*' ((':')?.*)? '*/'
    | expr NEWLINE
    {
          System.out.println($expr.i);
    }
    | ID '=' expr NEWLINE
        {
	  String id = $ID.text;
          vars.put(id, $expr.i);
          if ($expr.t == 1) {
            System.out.println($expr.i);
          }
	}
    | NEWLINE
;

expr returns [double i, int t]: 
    il = INT dot = '.' ir = INT
        {$i = Double.parseDouble($il.text + $dot.text + $ir.text);} 
    | er = expr op = (MULT | '/') el = expr 
    	{$i = eval($er.i, $op.type, $el.i);}
    | er = expr op = ('+' | '-') el = expr
    	{$i = eval($er.i, $op.type, $el.i);}
    | INT
        { $i=Integer.parseInt($INT.text);} 
    | ID
    	{ String id = $ID.text;
	$i = vars.containsKey(id) ? vars.get(id) : 0;
	}
    | 'sqrt(' e=expr ')' {
       $i = Math.sqrt($e.i); 
    }
    | 'read()' {
        Scanner reader = new Scanner(System.in);
        double n = reader.nextDouble();
        reader.close();
        $i = n;
    }
    | 's(' e = expr ')' {
        $i = Math.sin($e.i);
    }
    | 'c(' e = expr ')' {
        $i = Math.cos($e.i);
    }
    | 'l(' e = expr ')' {
        $i = Math.log($e.i);
    }
    | 'e(' e = expr ')' {
        $i = Math.exp($e.i);
    }
    | '(' e=expr ')'
    {
        $i = $e.i;
    }
    | er = expr op = (OR | AND) el = expr
        {$i = beval(false, $er.i, $op.text, $el.i);
         $t = 1;}
    | '!' '('? er = expr op = (OR | AND) el = expr ')'?
        {$i = beval(true, $er.i, $op.text, $el.i);
        $t=1;}
    | '!' e = expr
    	{$i = beval(true, $e.i, "||", 0);
	$t=1;}
    ;


liststat: expr ((COMMA liststat) | NEWLINE) {
    System.out.print($expr.i);
    };

printstat : 'print' liststat;

ID: [_A-Za-z]+ ;
EQUAL: '=';
INT: [0-9]+ ;		      
MULT: '*' ;
SUB: '-';
DIV: '/';
ADD: '+';
OR: '||';
AND: '&&';
NEWLINE:'\r'? '\n' ;
DQSTRING: '"' (~('"' | '\\' | '\r' | '\n') | '\\' ('"' | '\\'))* '"'; 
COMMA: ',';
WS: [ \t]+ -> skip ;

