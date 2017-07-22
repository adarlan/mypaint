Program AureaImageEditor1;
	Uses	crt;
	Const
		largura=65;
		altura=25;
		TAB=#9;
		ENTER=#13;
		ESC=#27;
		CTRL_N=#14;
		CTRL_C=#3;
		CTRL_V=#22;
		CTRL_X=#24;
		CTRL_Z=#26;
		CIMA=#72;
		BAIXO=#80;
		ESQUERDA=#75;
		DIREITA=#77;
		CTRL_S=#19;
		CTRL_O=#15;
	Var	imagem: array[1..largura,1..altura] of integer;
		cursor_x, cursor_y, cor, corbg, ferramenta: integer;
		tecla: char;
		arq: text;
	Function modulo(n: integer): integer;
		begin
			if n<0 then
				modulo:=n*(-1)
			else
				modulo:=n;
		end;
	Function inteiro(r: real): integer;
		var	i: integer;
		begin
			for i:=0 to 80 do
			begin
				if ((r >=i-0.1) and (r<=i+0.4)) then
				begin
					inteiro:=i;
					break;
				end;
				if ((r>=i-0.5) and (r<=i+1)) then
				begin
					inteiro:=i+1;
					break;
				end;
			end;
		end;
	Function menor(a,b: integer): integer;
		begin
			if a<b then
				menor:=a
			else
				menor:=b;
		end;
	Function maior(a,b: integer): integer;
		begin
			if a>b then
				maior:=a
			else
				maior:=b;
		end;
	Procedure desenharcursor;
		begin
			textbackground((23-imagem[cursor_x,cursor_y]) mod 8);
			textcolor(imagem[cursor_x,cursor_y]);
			gotoxy(cursor_x,cursor_y);
			write(#206);
			textbackground(7);
			textcolor(0);
			gotoxy(largura+2,altura);
			write(cursor_x-1,',',cursor_y-1,'  ');
		end;
	Procedure apagarcursor;
		begin
			textcolor(imagem[cursor_x,cursor_y]);
			gotoxy(cursor_x,cursor_y);
			write(#219);
			if (tecla=CIMA) and (cursor_y>1) then
				cursor_y:=cursor_y-1;
			if (tecla=BAIXO) and (cursor_y<altura) then
				cursor_y:=cursor_y+1;
			if (tecla=ESQUERDA) and (cursor_x>1) then
				cursor_x:=cursor_x-1;
			if (tecla=DIREITA) and (cursor_x<largura) then
				cursor_x:=cursor_x+1;
		end;
	Procedure lertecla;
		var	x, y: integer;
			caractere: char;
		begin
			desenharcursor;
			gotoxy(80,25);
			tecla:=readkey;
			if tecla=CTRL_N then
			begin
				for x:=1 to largura do
				begin
					for y:=1 to altura do
					begin
						imagem[x,y]:=corbg;
						gotoxy(x,y);
						textcolor(corbg);
						write(#219);
					end;
				end;
			end;
			if tecla=CTRL_S then
			begin
				assign(arq,'imagem.aur');
				rewrite(arq);
				for x:=1 to largura do
					for y:=1 to altura do
						writeln(arq,chr(imagem[x,y]+65));
				close(arq);
			end;
			if tecla=CTRL_O then
			begin
				assign(arq,'imagem.aur');
				reset(arq);
				for x:=1 to largura do
				begin
					for y:=1 to altura do
					begin
						readln(arq,caractere);
						imagem[x,y]:=ord(caractere)-65;
						textcolor(imagem[x,y]);
						gotoxy(x,y);
						write(#219);
					end;
				end;
				close(arq);
			end;
			apagarcursor;
		end;
	Procedure desenharimagem;
		var	x, y: integer;
		begin
			for x:=1 to largura do
			begin
				for y:=1 to altura do
				begin
					textcolor(imagem[x,y]);
					gotoxy(x,y);
					write(#219);
				end;
			end;
		end;
	Procedure limparimagem;
		var	x, y: integer;
		begin
			for x:=1 to largura do
				for y:=1 to altura do
					imagem[x,y]:=corbg;
			desenharimagem;
		end;
	Procedure colorir(x1,y1,cor1: integer);
		var	x, y: integer;
			ok: boolean;
			m: array[1..largura,1..altura] of integer;
		begin
			for x:=1 to largura do
				for y:=1 to altura do
					m[x,y]:=0;
			m[x1,y1]:=1;
			repeat
				ok:=true;
				for x:=1 to largura do
				begin
					for y:=1 to altura do
					begin
						if m[x,y]=1 then
						begin
							if y>1 then
								if (imagem[x,y-1]=imagem[x1,y1]) and (m[x,y-1]=0) then
									m[x,y-1]:=1;
							if y<altura then
								if (imagem[x,y+1]=imagem[x1,y1]) and (m[x,y+1]=0) then
									m[x,y+1]:=1;
							if x>1 then
								if (imagem[x-1,y]=imagem[x1,y1]) and (m[x-1,y]=0) then
									m[x-1,y]:=1;
							if x<largura then
								if (imagem[x+1,y]=imagem[x1,y1]) and (m[x+1,y]=0) then
									m[x+1,y]:=1;
							ok:=false;
							m[x,y]:=2;
						end;
					end;
				end;
			until ok;
			for x:=1 to largura do
			begin
				for y:=1 to altura do
				begin
					if m[x,y]=2 then
						imagem[x,y]:=cor1;
				end;
			end;
		end;
	Procedure inicio;
		var	i: integer;
		begin
			textbackground(7);
			clrscr;
			corbg:=15;
			cor:=0;
			limparimagem;
			cursor_x:=1;
			cursor_y:=1;
			ferramenta:=5;
			textcolor(4);
			gotoxy(67,11);	write(#218,#196,#196,#196,#191);
			gotoxy(67,12);	write(#179, ' ', ' ', ' ',#179);
			gotoxy(67,13);	write(#192,#196,#196,#196,#217);
			textcolor(8);
			gotoxy(68,4);	write('SEL');
			textcolor(0);
			gotoxy(68,6);	write('BOR');
			gotoxy(68,8);	write('PRE');
			textcolor(8);
			gotoxy(68,10);	write('COR');
			textcolor(0);
			gotoxy(68,12);	write('LAP');
			gotoxy(68,14);	write('PIN');
			textcolor(8);
			gotoxy(68,16);	write('SPR');
			textcolor(0);
			gotoxy(68,18);	write('LIN');
			gotoxy(68,20);	write('RET');
			gotoxy(68,22);	write('CIR');
			textcolor(4);
			gotoxy(73,1);	write(#218,#196,#196,#191);
			gotoxy(73,2);	write(#179, ' ', ' ',#179);
			gotoxy(73,3);	write(#179, ' ', ' ',#179);
			gotoxy(73,4);	write(#192,#196,#196,#217);
			for i:=0 to 15 do
			begin
				textcolor(i);
				if (i<=7) then
				begin
					gotoxy(74, 3*i+2);	write(#219,#219);
					gotoxy(74, 3*i+3);	write(#219,#219);
				end
				else
				begin
					gotoxy(77, 3*i-22);	write(#219,#219);
					gotoxy(77, 3*i-21);	write(#219,#219);
				end;
			end;
			textcolor(8);
			for i:=1 to 24 do
			begin
				gotoxy(66,i);
				write(#179);
				gotoxy(72,i);
				write(#179);
				gotoxy(80,i);
				write(#179);
			end;
		end;
	Procedure menuferramentas;
		var	x, y: integer;
		begin
			x:=67;
			y:=2*ferramenta+1;
			repeat
				textbackground(7);
				textcolor(14);
				gotoxy(x,y);	write(#218,#196,#196,#196,#191);
				gotoxy(x,y+1);	write(#179);	gotoxy(x+4,y+1);	write(#179);
				gotoxy(x,y+2);	write(#192,#196,#196,#196,#217);
				gotoxy(80,25);
				tecla:=readkey;
				gotoxy(x,y);	write('     ');
				gotoxy(x,y+1);	write(' ');	gotoxy(x+4,y+1);	write(' ');
				gotoxy(x,y+2);	write('     ');
				if (tecla=#72) and (y>3) then
					y:=y-2;
				if (tecla=#80) and (y<21) then
					y:=y+2;
				if (tecla=#13) then
					ferramenta:=(y-1) div 2;
			until (tecla=TAB) or (tecla=ENTER) or (tecla=ESC);
			y:=2*ferramenta+1;
			textcolor(4);
			gotoxy(x,y);	write(#218,#196,#196,#196,#191);
			gotoxy(x,y+1);	write(#179);	gotoxy(x+4,y+1);	write(#179);
			gotoxy(x,y+2);	write(#192,#196,#196,#196,#217);
		end;
	Procedure menucores;
		var	x, y: integer;
		begin
			textbackground(7);
			x:=73+(3*(cor div 8));
			if (cor>=0) and (cor<=7) then y:=3*cor+1
			else y:=3*cor-23;
			repeat
				textcolor(14);
				gotoxy(x,y);	write(#218,#196,#196,#191);
				gotoxy(x,y+1);	write(#179);	gotoxy(x+3,y+1);	write(#179);
				gotoxy(x,y+2);	write(#179);	gotoxy(x+3,y+2);	write(#179);
				gotoxy(x,y+3);	write(#192,#196,#196,#217);
				gotoxy(80,25);
				tecla:=readkey;
				gotoxy(x,y);	write('    ');
				gotoxy(x,y+1);	write(' ');	gotoxy(x+3,y+1);	write(' ');
				gotoxy(x,y+2);	write(' ');	gotoxy(x+3,y+2);	write(' ');
				gotoxy(x,y+3);	write('    ');
				if (tecla=CIMA) and (y>1) then y:=y-3;
				if (tecla=BAIXO) and (y<22) then y:=y+3;
				if (tecla=ESQUERDA) and (x>74) then x:=x-3;
				if (tecla=DIREITA) and (x<76) then x:=x+3;
				if (tecla=ENTER) then cor:=((y-1) div 3)+(((8*(x-4)) div 3)-184);
			until (tecla=TAB) or (tecla=ENTER) or (tecla=ESC);
			x:=73+(3*(cor div 8));
			if (cor>=0) and (cor<=7) then y:=3*cor+1
			else y:=3*cor-23;
			textcolor(4);
			gotoxy(x,y);	write(#218,#196,#196,#191);
			gotoxy(x,y+1);	write(#179);	gotoxy(x+3,y+1);	write(#179);
			gotoxy(x,y+2);	write(#179);	gotoxy(x+3,y+2);	write(#179);
			gotoxy(x,y+3);	write(#192,#196,#196,#217);
		end;
{--------------FERRAMENTAS--------------}
	Procedure selecionar;
		begin
		end;
	Procedure borracha;
		var	apagar: boolean;
		begin
			apagar:=false;
			repeat
				lertecla;
				if tecla=ENTER then
					apagar:=not(apagar);
				if apagar then
				begin
					imagem[cursor_x,cursor_y]:=corbg;
					textcolor(corbg);
					gotoxy(cursor_x,cursor_y);
					write(#219);
				end;
			until ((tecla=TAB) or (tecla=ESC));
		end;
	Procedure preencher;
		begin
			repeat
				lertecla;
				if tecla=ENTER then
				begin
					colorir(cursor_x,cursor_y,cor);
					desenharimagem;
				end;
			until ((tecla=TAB) or (tecla=ESC));
		end;
	Procedure selecionarcor;
		begin
		end;
	Procedure lapis;
		begin
			repeat
				lertecla;
				if tecla=ENTER then
				begin
					imagem[cursor_x,cursor_y]:=cor;
					textcolor(cor);
					gotoxy(cursor_x,cursor_y);
					write(#219);
				end;
			until ((tecla=TAB) or (tecla=ESC));
		end;
	Procedure pincel;
		var	pintar: boolean;
		begin
			pintar:=false;
			repeat
				lertecla;
				if tecla=ENTER then
					pintar:=not(pintar);
				if pintar then
				begin
					imagem[cursor_x,cursor_y]:=cor;
					textcolor(cor);
					gotoxy(cursor_x,cursor_y);
					write(#219);
				end;
			until ((tecla=TAB) or (tecla=ESC));
		end;
	Procedure spray;
		begin
		end;
	Procedure linha;
		var	x, y, x1, y1, x2, y2: integer;
			a, b: real;
		begin
			repeat
				x1:=0;
				y1:=0;
				while (x1=0) and (y1=0) do
				begin
					lertecla;
					if tecla=ENTER then
					begin
						x1:=cursor_x;
						y1:=cursor_y;
					end;
					if (tecla=ESC) or (tecla=TAB) then
						break;
				end;
				while (x1>0) and (y1>0) do
				begin
					x2:=cursor_x;
					y2:=cursor_y;
					if y1=y2 then
						a:=0
					else
						a:=(x2-x1)/(y2-y1);
					b:=x1-a*y1;
					for y:=menor(y1,y2) to maior(y1,y2) do
					begin
						x:=inteiro(a*y+b);
						textcolor(cor);
						gotoxy(x,y);
						write(#219);
					end;
					if x1=x2 then
						a:=0
					else
						a:=(y2-y1)/(x2-x1);
					b:=y1-a*x1;
					for x:=menor(x1,x2) to maior(x1,x2) do
					begin
						y:=inteiro(a*x+b);
						textcolor(cor);
						gotoxy(x,y);
						write(#219);
					end;
					lertecla;
					if tecla=ENTER then
					begin
						if y1=cursor_y then
							a:=0
						else
							a:=(cursor_x-x1)/(cursor_y-y1);
						b:=x1-a*y1;
						for y:=menor(y1,cursor_y) to maior(y1,cursor_y) do
						begin
							x:=inteiro(a*y+b);
							imagem[x,y]:=cor;
						end;
						if x1=cursor_x then
							a:=0
						else
							a:=(cursor_y-y1)/(cursor_x-x1);
						b:=y1-a*x1;
						for x:=menor(x1,cursor_x) to maior(x1,cursor_x) do
						begin
							y:=inteiro(a*x+b);
							imagem[x,y]:=cor;
						end;
						x1:=0;
						y1:=0;
					end
					else
					begin
						if y1=y2 then
							a:=0
						else
							a:=(x2-x1)/(y2-y1);
						b:=x1-a*y1;
						for y:=menor(y1,y2) to maior(y1,y2) do
						begin
							x:=inteiro(a*y+b);
							textcolor(imagem[x,y]);
							gotoxy(x,y);
							write(#219);
						end;
						if x1=x2 then
							a:=0
						else
							a:=(y2-y1)/(x2-x1);
						b:=y1-a*x1;
						for x:=menor(x1,x2) to maior(x1,x2) do
						begin
							y:=inteiro(a*x+b);
							textcolor(imagem[x,y]);
							gotoxy(x,y);
							write(#219);
						end;
					end;
					if (tecla=ESC) or (tecla=TAB) then
						break;
				end;
			until (tecla=ESC) or (tecla=TAB);
		end;
	Procedure retangulo;
		var	x, y, x1, y1, x2, y2: integer;
		begin
			repeat
				x1:=0;
				y1:=0;
				while (x1=0) and (y1=0) do
				begin
					lertecla;
					if tecla=ENTER then
					begin
						x1:=cursor_x;
						y1:=cursor_y;
					end;
					if (tecla=ESC) or (tecla=TAB) then
						break;
				end;
				while (x1>0) and (y1>0) do
				begin
					x2:=cursor_x;
					y2:=cursor_y;
					for x:=menor(x1,x2) to maior(x1,x2) do
					begin
						textcolor(cor);
						gotoxy(x,y1);
						write(#219);
						gotoxy(x,y2);
						write(#219);
					end;
					for y:=menor(y1,y2) to maior(y1,y2) do
					begin
						textcolor(cor);
						gotoxy(x1,y);
						write(#219);
						gotoxy(x2,y);
						write(#219);
					end;
					lertecla;
					if tecla=ENTER then
					begin
						for x:=menor(x1,cursor_x) to maior(x1,cursor_x) do
						begin
							imagem[x,y1]:=cor;
							imagem[x,cursor_y]:=cor;
						end;
						for y:=menor(y1,cursor_y) to maior(y1,cursor_y) do
						begin
							imagem[x1,y]:=cor;
							imagem[cursor_x,y]:=cor;
						end;
						x1:=0;
						y1:=0;
					end
					else
					begin
						for x:=menor(x1,x2) to maior(x1,x2) do
						begin
							textcolor(imagem[x,y1]);
							gotoxy(x,y1);
							write(#219);
							textcolor(imagem[x,y2]);
							gotoxy(x,y2);
							write(#219);
						end;
						for y:=menor(y1,y2) to maior(y1,y2) do
						begin
							textcolor(imagem[x1,y]);
							gotoxy(x1,y);
							write(#219);
							textcolor(imagem[x2,y]);
							gotoxy(x2,y);
							write(#219);
						end;
					end;
					if (tecla=ESC) or (tecla=TAB) then
						break;
				end;
			until (tecla=ESC) or (tecla=TAB);
		end;
	Procedure circulo;
		var	x1, y1, x2, y2, diametro, x, y, _x1, _y1, _x2, _y2: integer;
			raio, Ox, Oy: real;
		begin
			repeat
				x1:=0;
				y1:=0;
				while (x1=0) and (y1=0) do
				begin
					lertecla;
					if tecla=ENTER then
					begin
						x1:=cursor_x;
						y1:=cursor_y;
					end;
					if (tecla=ESC) or (tecla=TAB) then
						break;
				end;
				while (x1>0) and (y1>0) do
				begin
					x2:=cursor_x;
					y2:=cursor_y;
					// Desenhar
					diametro:=menor((maior(x1,x2)-menor(x1,x2)),(maior(y1,y2)-menor(y1,y2)));
					raio:=diametro/2;
					if x1<x2 then
						Ox:=x1+raio;
					if x2<x1 then
						Ox:=x1-raio;
					if y1<y2 then
						Oy:=y1+raio;
					if y2<y1 then
						Oy:=y1-raio;
					if x1<x2 then
					begin
						_x1:=x1;
						_x2:=x1+diametro;
					end;
					if x2<x1 then
					begin
						_x1:=x1-diametro;
						_x2:=x1;
					end;
					if y1<y2 then
					begin
						_y1:=y1;
						_y2:=y1+diametro;
					end;
					if y2<y1 then
					begin
						_y1:=y1-diametro;
						_y2:=y1;
					end;
					textcolor(cor);
					if not((x1=x2) or (y1=y2)) then
					begin
						for x:=_x1 to _x2 do
						begin
							y:=inteiro(Oy+(sqrt(1-sqr((x-Ox)/raio)))*raio);
							gotoxy(x,y);
							write(#219);
							y:=inteiro(Oy-(sqrt(1-sqr((x-Ox)/raio)))*raio);
							gotoxy(x,y);
							write(#219);
						end;
						for y:=_y1 to _y2 do
						begin
							x:=inteiro(Ox+(sqrt(1-sqr((y-Oy)/raio)))*raio);
							gotoxy(x,y);
							write(#219);
							x:=inteiro(Ox-(sqrt(1-sqr((y-Oy)/raio)))*raio);
							gotoxy(x,y);
							write(#219);
						end;
					end;
					//---------
					lertecla;
					if tecla=ENTER then
					begin
						x2:=cursor_x;
						y2:=cursor_y;
						// Atribuir
						diametro:=menor((maior(x1,x2)-menor(x1,x2)),(maior(y1,y2)-menor(y1,y2)));
						raio:=diametro/2;
						if x1<x2 then
							Ox:=x1+raio;
						if x2<x1 then
							Ox:=x1-raio;
						if y1<y2 then
							Oy:=y1+raio;
						if y2<y1 then
							Oy:=y1-raio;
						if x1<x2 then
						begin
							_x1:=x1;
							_x2:=x1+diametro;
						end;
						if x2<x1 then
						begin
							_x1:=x1-diametro;
							_x2:=x1;
						end;
						if y1<y2 then
						begin
							_y1:=y1;
							_y2:=y1+diametro;
						end;
						if y2<y1 then
						begin
							_y1:=y1-diametro;
							_y2:=y1;
						end;
						if not((x1=x2) or (y1=y2)) then
						begin
							for x:=_x1 to _x2 do
							begin
								y:=inteiro(Oy+(sqrt(1-sqr((x-Ox)/raio)))*raio);
								imagem[x,y]:=cor;
								y:=inteiro(Oy-(sqrt(1-sqr((x-Ox)/raio)))*raio);
								imagem[x,y]:=cor;
							end;
							for y:=_y1 to _y2 do
							begin
								x:=inteiro(Ox+(sqrt(1-sqr((y-Oy)/raio)))*raio);
								imagem[x,y]:=cor;
								x:=inteiro(Ox-(sqrt(1-sqr((y-Oy)/raio)))*raio);
								imagem[x,y]:=cor;
							end;
						end;
						//---------
						x1:=0;
						y1:=0;
					end
					else
					begin
						// Apagar
						if not((x1=x2) or (y1=y2)) then
						begin
							for x:=_x1 to _x2 do
							begin
								y:=inteiro(Oy+(sqrt(1-sqr((x-Ox)/raio)))*raio);
								textcolor(imagem[x,y]);
								gotoxy(x,y);
								write(#219);
								y:=inteiro(Oy-(sqrt(1-sqr((x-Ox)/raio)))*raio);
								textcolor(imagem[x,y]);
								gotoxy(x,y);
								write(#219);
							end;
							for y:=_y1 to _y2 do
							begin
								x:=inteiro(Ox+(sqrt(1-sqr((y-Oy)/raio)))*raio);
								textcolor(imagem[x,y]);
								gotoxy(x,y);
								write(#219);
								x:=inteiro(Ox-(sqrt(1-sqr((y-Oy)/raio)))*raio);
								textcolor(imagem[x,y]);
								gotoxy(x,y);
								write(#219);
							end;
						end;
						//-------
					end;
					if (tecla=ESC) or (tecla=TAB) then
						break;
				end;
			until (tecla=ESC) or (tecla=TAB);
		end;
		
	Begin
		inicio;
		repeat
			case ferramenta of
				1: selecionar;
				2: borracha;
				3: preencher;
				4: selecionarcor;
				5: lapis;
				6: pincel;
				7: spray;
				8: linha;
				9: retangulo;
				10: circulo;
			end;
			if tecla=TAB then
				menuferramentas;
			if tecla=TAB then
				menucores;
		until tecla=ESC;
	End.
