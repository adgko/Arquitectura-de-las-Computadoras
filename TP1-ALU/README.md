# TP1 ALU

En este proyecto, se llevó a cabo un módulo ALU en lenguaje Verilog, se lo testeó en simulación y se lo llevó a una placa Basys 3.

## Funcionamiento
El módulo debía poder resolver las instrucciones de los siguientes opcodes
![](https://github.com/adgko/Arquitectura-de-las-Computadoras/blob/main/TP1-ALU/ALU_OP.jpeg)

En la placa, se debía ingresar por los switch hasta 8 bits, un valor. Este luego sería ingresado a los registros A, B u OP, dependiendo cual de tres botones se tocase. Estos elegían donde se guardaría.
Los registros A y B funcionan como operandos, mientras que OP guarda el opcode de la operación, guardando solamente 6 bits.
El resultado de la operación en la ALU se debe mostrar por leds.
El siguiente esquemático muestra la topología del proyecto.

![](https://github.com/adgko/Arquitectura-de-las-Computadoras/blob/main/TP1-ALU/ALU_Schem.jpeg)

## Módulo ALU
El módulo alu.v en si fue fácil de desarrollar. Consiste en la definición de parámetros, entradas y salidas, y luego un bloque always que evalúa el valor de OP y en base a eso, realiza la operación solicitada, guardando el valor en un registro.

Se testeó con el testbench tb_alu.v probando cada operación y resultó exitoso.

## Módulo Top
El módulo top.v consiste en los parámetros, entras y salidas, y también registros que recibirán los datos al presionar los botones correspondientes. Luego instancia la alu, conectando los registros con los valores correspondientes.	
Lo que se coloque en los switch, encenderá leds que mostrarán el valor que estamos trabajando.
Luego evalúa que botón se presiona, y de esa forma sabe a que registro enviar el valor correspondiente.
Por ultimo, recibe el valor de resultado de ALU y lo asigna a los siguientes leds, para mostrar el resultado.

Para probar esto, se empleó tb_top.v que simula entradas en el switch, simula presionar los botones, y lee el resultado final obtenido en los switch.

## Funcionamiento en la Placa
Para terminar el proyecto, se agregó el archivo constraints, se comentó lo que no se usaría y se aseguró que los nombres coincidían con los del top.
Luego se corrió síntesis, implementación y generación de bitstream para agregarlo dentro, y se presentó en clase.

En la evaluación, se explicó lo que hacían los módulos alu.v y top.v, y se usó la placa para resolver operaciones que nos pidieron, demostrando que funcionaba.

## Conclusión
El trabajo nos acercó a la programación en Verilog, a la lógica de bloques, al uso de constraints y al testing en vivado.
