
build/kernel.elf:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00002117          	auipc	sp,0x2
    80000004:	22010113          	addi	sp,sp,544 # 80002220 <stack0>
    80000008:	00001537          	lui	a0,0x1
    8000000c:	00250133          	add	sp,a0,sp
    80000010:	35c000ef          	jal	ra,8000036c <main>

0000000080000014 <spin>:
    80000014:	0000006f          	j	80000014 <spin>

0000000080000018 <printint.constprop.0>:
        uartputc(c);
    }
}

static void
printint(int xx, int base, int sign)
    80000018:	fd010113          	addi	sp,sp,-48
    8000001c:	02813023          	sd	s0,32(sp)
    80000020:	02113423          	sd	ra,40(sp)
    80000024:	00913c23          	sd	s1,24(sp)
    80000028:	01213823          	sd	s2,16(sp)
    8000002c:	03010413          	addi	s0,sp,48
    80000030:	00050313          	mv	t1,a0
    char buf[16];
    int i;
    uint32_t x;

    if (sign && (sign = xx < 0))
        x = -xx;
    80000034:	40a0073b          	negw	a4,a0
    if (sign && (sign = xx < 0))
    80000038:	00054463          	bltz	a0,80000040 <printint.constprop.0+0x28>
    8000003c:	0005071b          	sext.w	a4,a0
        x = xx;

    i = 0;
    do
    {
        buf[i++] = digits[x % base];
    80000040:	0005859b          	sext.w	a1,a1
    80000044:	fd040693          	addi	a3,s0,-48
    80000048:	00000613          	li	a2,0
    8000004c:	00002897          	auipc	a7,0x2
    80000050:	fc488893          	addi	a7,a7,-60 # 80002010 <digits>
    80000054:	02b777bb          	remuw	a5,a4,a1
    } while ((x /= base) != 0);
    80000058:	00168693          	addi	a3,a3,1
    8000005c:	0007081b          	sext.w	a6,a4
    80000060:	00060493          	mv	s1,a2
        buf[i++] = digits[x % base];
    80000064:	0016061b          	addiw	a2,a2,1
    80000068:	02079793          	slli	a5,a5,0x20
    8000006c:	0207d793          	srli	a5,a5,0x20
    80000070:	00f887b3          	add	a5,a7,a5
    80000074:	0007c503          	lbu	a0,0(a5)
    } while ((x /= base) != 0);
    80000078:	02b7573b          	divuw	a4,a4,a1
        buf[i++] = digits[x % base];
    8000007c:	fea68fa3          	sb	a0,-1(a3)
    } while ((x /= base) != 0);
    80000080:	fcb87ae3          	bgeu	a6,a1,80000054 <printint.constprop.0+0x3c>

    if (sign)
    80000084:	00035e63          	bgez	t1,800000a0 <printint.constprop.0+0x88>
        buf[i++] = '-';
    80000088:	fe060793          	addi	a5,a2,-32
    8000008c:	008787b3          	add	a5,a5,s0
    80000090:	02d00713          	li	a4,45
    80000094:	fee78823          	sb	a4,-16(a5)
        buf[i++] = digits[x % base];
    80000098:	00060493          	mv	s1,a2
        buf[i++] = '-';
    8000009c:	02d00513          	li	a0,45

    while (--i >= 0)
    800000a0:	fd040793          	addi	a5,s0,-48
    800000a4:	009784b3          	add	s1,a5,s1
    800000a8:	00078913          	mv	s2,a5
    800000ac:	00c0006f          	j	800000b8 <printint.constprop.0+0xa0>
        consputc(buf[i]);
    800000b0:	fff4c503          	lbu	a0,-1(s1)
    800000b4:	fff48493          	addi	s1,s1,-1
        uartputc(c);
    800000b8:	00000097          	auipc	ra,0x0
    800000bc:	360080e7          	jalr	864(ra) # 80000418 <uartputc>
    while (--i >= 0)
    800000c0:	ff2498e3          	bne	s1,s2,800000b0 <printint.constprop.0+0x98>
}
    800000c4:	02813083          	ld	ra,40(sp)
    800000c8:	02013403          	ld	s0,32(sp)
    800000cc:	01813483          	ld	s1,24(sp)
    800000d0:	01013903          	ld	s2,16(sp)
    800000d4:	03010113          	addi	sp,sp,48
    800000d8:	00008067          	ret

00000000800000dc <consputc>:
    if (c == BACKSPACE)
    800000dc:	10000793          	li	a5,256
    800000e0:	00f50863          	beq	a0,a5,800000f0 <consputc+0x14>
        uartputc(c);
    800000e4:	0ff57513          	zext.b	a0,a0
    800000e8:	00000317          	auipc	t1,0x0
    800000ec:	33030067          	jr	816(t1) # 80000418 <uartputc>
{
    800000f0:	ff010113          	addi	sp,sp,-16
    800000f4:	00113423          	sd	ra,8(sp)
    800000f8:	00813023          	sd	s0,0(sp)
    800000fc:	01010413          	addi	s0,sp,16
        uartputc('\b');
    80000100:	00800513          	li	a0,8
    80000104:	00000097          	auipc	ra,0x0
    80000108:	314080e7          	jalr	788(ra) # 80000418 <uartputc>
        uartputc(' ');
    8000010c:	02000513          	li	a0,32
    80000110:	00000097          	auipc	ra,0x0
    80000114:	308080e7          	jalr	776(ra) # 80000418 <uartputc>
}
    80000118:	00013403          	ld	s0,0(sp)
    8000011c:	00813083          	ld	ra,8(sp)
        uartputc('\b');
    80000120:	00800513          	li	a0,8
}
    80000124:	01010113          	addi	sp,sp,16
        uartputc('\b');
    80000128:	00000317          	auipc	t1,0x0
    8000012c:	2f030067          	jr	752(t1) # 80000418 <uartputc>

0000000080000130 <printf>:
        consputc(digits[x >> (sizeof(uint64_t) * 8 - 4)]);
}

// Print to the console. only understands %d, %x, %p, %s.
void printf(char *fmt, ...)
{
    80000130:	f5010113          	addi	sp,sp,-176
    80000134:	06813023          	sd	s0,96(sp)
    80000138:	05313423          	sd	s3,72(sp)
    8000013c:	07010413          	addi	s0,sp,112
    80000140:	06113423          	sd	ra,104(sp)
    80000144:	04913c23          	sd	s1,88(sp)
    80000148:	05213823          	sd	s2,80(sp)
    8000014c:	05413023          	sd	s4,64(sp)
    80000150:	03513c23          	sd	s5,56(sp)
    80000154:	03613823          	sd	s6,48(sp)
    80000158:	03713423          	sd	s7,40(sp)
    8000015c:	03813023          	sd	s8,32(sp)
    80000160:	01913c23          	sd	s9,24(sp)
    80000164:	00050993          	mv	s3,a0
    va_list ap;
    int i, c;
    char *s;

    va_start(ap, fmt);
    for (i = 0; (c = fmt[i] & 0xff) != 0; i++)
    80000168:	00054503          	lbu	a0,0(a0) # 1000 <_entry-0x7ffff000>
{
    8000016c:	02f43423          	sd	a5,40(s0)
    va_start(ap, fmt);
    80000170:	00840793          	addi	a5,s0,8
{
    80000174:	00b43423          	sd	a1,8(s0)
    80000178:	00c43823          	sd	a2,16(s0)
    8000017c:	00d43c23          	sd	a3,24(s0)
    80000180:	02e43023          	sd	a4,32(s0)
    80000184:	03043823          	sd	a6,48(s0)
    80000188:	03143c23          	sd	a7,56(s0)
    va_start(ap, fmt);
    8000018c:	f8f43c23          	sd	a5,-104(s0)
    for (i = 0; (c = fmt[i] & 0xff) != 0; i++)
    80000190:	06050c63          	beqz	a0,80000208 <printf+0xd8>
    80000194:	0005079b          	sext.w	a5,a0
    80000198:	00000913          	li	s2,0
    {
        if (c != '%')
    8000019c:	02500a93          	li	s5,37
            continue;
        }
        c = fmt[++i] & 0xff;
        if (c == 0)
            break;
        switch (c)
    800001a0:	07000b13          	li	s6,112
    800001a4:	00002a17          	auipc	s4,0x2
    800001a8:	e6ca0a13          	addi	s4,s4,-404 # 80002010 <digits>
    800001ac:	07300c13          	li	s8,115
    800001b0:	06400b93          	li	s7,100
        if (c != '%')
    800001b4:	0d579263          	bne	a5,s5,80000278 <printf+0x148>
        c = fmt[++i] & 0xff;
    800001b8:	0019091b          	addiw	s2,s2,1
    800001bc:	012987b3          	add	a5,s3,s2
    800001c0:	0007c483          	lbu	s1,0(a5)
        if (c == 0)
    800001c4:	04048263          	beqz	s1,80000208 <printf+0xd8>
        switch (c)
    800001c8:	0d648663          	beq	s1,s6,80000294 <printf+0x164>
    800001cc:	069b6863          	bltu	s6,s1,8000023c <printf+0x10c>
    800001d0:	0b548a63          	beq	s1,s5,80000284 <printf+0x154>
    800001d4:	09749a63          	bne	s1,s7,80000268 <printf+0x138>
        {
        case 'd':
            printint(va_arg(ap, int), 10, 1);
    800001d8:	f9843783          	ld	a5,-104(s0)
    800001dc:	00a00593          	li	a1,10
    800001e0:	0007a503          	lw	a0,0(a5)
    800001e4:	00878793          	addi	a5,a5,8
    800001e8:	f8f43c23          	sd	a5,-104(s0)
    800001ec:	00000097          	auipc	ra,0x0
    800001f0:	e2c080e7          	jalr	-468(ra) # 80000018 <printint.constprop.0>
    for (i = 0; (c = fmt[i] & 0xff) != 0; i++)
    800001f4:	0019091b          	addiw	s2,s2,1
    800001f8:	012987b3          	add	a5,s3,s2
    800001fc:	0007c503          	lbu	a0,0(a5)
    80000200:	0005079b          	sext.w	a5,a0
    80000204:	fa0518e3          	bnez	a0,800001b4 <printf+0x84>
            consputc(c);
            break;
        }
    }
    va_end(ap);
}
    80000208:	06813083          	ld	ra,104(sp)
    8000020c:	06013403          	ld	s0,96(sp)
    80000210:	05813483          	ld	s1,88(sp)
    80000214:	05013903          	ld	s2,80(sp)
    80000218:	04813983          	ld	s3,72(sp)
    8000021c:	04013a03          	ld	s4,64(sp)
    80000220:	03813a83          	ld	s5,56(sp)
    80000224:	03013b03          	ld	s6,48(sp)
    80000228:	02813b83          	ld	s7,40(sp)
    8000022c:	02013c03          	ld	s8,32(sp)
    80000230:	01813c83          	ld	s9,24(sp)
    80000234:	0b010113          	addi	sp,sp,176
    80000238:	00008067          	ret
        switch (c)
    8000023c:	0b848463          	beq	s1,s8,800002e4 <printf+0x1b4>
    80000240:	07800793          	li	a5,120
    80000244:	02f49263          	bne	s1,a5,80000268 <printf+0x138>
            printint(va_arg(ap, int), 16, 1);
    80000248:	f9843783          	ld	a5,-104(s0)
    8000024c:	01000593          	li	a1,16
    80000250:	0007a503          	lw	a0,0(a5)
    80000254:	00878793          	addi	a5,a5,8
    80000258:	f8f43c23          	sd	a5,-104(s0)
    8000025c:	00000097          	auipc	ra,0x0
    80000260:	dbc080e7          	jalr	-580(ra) # 80000018 <printint.constprop.0>
            break;
    80000264:	f91ff06f          	j	800001f4 <printf+0xc4>
        uartputc(c);
    80000268:	02500513          	li	a0,37
    8000026c:	00000097          	auipc	ra,0x0
    80000270:	1ac080e7          	jalr	428(ra) # 80000418 <uartputc>
    80000274:	00048513          	mv	a0,s1
    80000278:	00000097          	auipc	ra,0x0
    8000027c:	1a0080e7          	jalr	416(ra) # 80000418 <uartputc>
    80000280:	f75ff06f          	j	800001f4 <printf+0xc4>
    80000284:	02500513          	li	a0,37
    80000288:	00000097          	auipc	ra,0x0
    8000028c:	190080e7          	jalr	400(ra) # 80000418 <uartputc>
}
    80000290:	f65ff06f          	j	800001f4 <printf+0xc4>
            printptr(va_arg(ap, uint64_t));
    80000294:	f9843783          	ld	a5,-104(s0)
        uartputc(c);
    80000298:	03000513          	li	a0,48
    8000029c:	01000c93          	li	s9,16
            printptr(va_arg(ap, uint64_t));
    800002a0:	00878713          	addi	a4,a5,8
    800002a4:	0007b483          	ld	s1,0(a5)
    800002a8:	f8e43c23          	sd	a4,-104(s0)
        uartputc(c);
    800002ac:	00000097          	auipc	ra,0x0
    800002b0:	16c080e7          	jalr	364(ra) # 80000418 <uartputc>
    800002b4:	07800513          	li	a0,120
    800002b8:	00000097          	auipc	ra,0x0
    800002bc:	160080e7          	jalr	352(ra) # 80000418 <uartputc>
        consputc(digits[x >> (sizeof(uint64_t) * 8 - 4)]);
    800002c0:	03c4d793          	srli	a5,s1,0x3c
    800002c4:	00fa07b3          	add	a5,s4,a5
        uartputc(c);
    800002c8:	0007c503          	lbu	a0,0(a5)
    for (i = 0; i < (sizeof(uint64_t) * 2); i++, x <<= 4)
    800002cc:	fffc8c9b          	addiw	s9,s9,-1
    800002d0:	00449493          	slli	s1,s1,0x4
        uartputc(c);
    800002d4:	00000097          	auipc	ra,0x0
    800002d8:	144080e7          	jalr	324(ra) # 80000418 <uartputc>
    for (i = 0; i < (sizeof(uint64_t) * 2); i++, x <<= 4)
    800002dc:	fe0c92e3          	bnez	s9,800002c0 <printf+0x190>
    800002e0:	f15ff06f          	j	800001f4 <printf+0xc4>
            if ((s = va_arg(ap, char *)) == 0)
    800002e4:	f9843783          	ld	a5,-104(s0)
    800002e8:	0007b483          	ld	s1,0(a5)
    800002ec:	00878793          	addi	a5,a5,8
    800002f0:	f8f43c23          	sd	a5,-104(s0)
    800002f4:	00049a63          	bnez	s1,80000308 <printf+0x1d8>
    800002f8:	01c0006f          	j	80000314 <printf+0x1e4>
            for (; *s; s++)
    800002fc:	00148493          	addi	s1,s1,1
        uartputc(c);
    80000300:	00000097          	auipc	ra,0x0
    80000304:	118080e7          	jalr	280(ra) # 80000418 <uartputc>
            for (; *s; s++)
    80000308:	0004c503          	lbu	a0,0(s1)
    8000030c:	fe0518e3          	bnez	a0,800002fc <printf+0x1cc>
    80000310:	ee5ff06f          	j	800001f4 <printf+0xc4>
                s = "(null)";
    80000314:	00002497          	auipc	s1,0x2
    80000318:	cec48493          	addi	s1,s1,-788 # 80002000 <syscall+0x1f0>
            for (; *s; s++)
    8000031c:	02800513          	li	a0,40
    80000320:	fddff06f          	j	800002fc <printf+0x1cc>

0000000080000324 <panic>:

void panic(char *s)
{
    80000324:	fe010113          	addi	sp,sp,-32
    80000328:	00113c23          	sd	ra,24(sp)
    8000032c:	00813823          	sd	s0,16(sp)
    80000330:	00913423          	sd	s1,8(sp)
    80000334:	02010413          	addi	s0,sp,32
    80000338:	00050493          	mv	s1,a0
    printf("panic: ");
    8000033c:	00002517          	auipc	a0,0x2
    80000340:	ccc50513          	addi	a0,a0,-820 # 80002008 <syscall+0x1f8>
    80000344:	00000097          	auipc	ra,0x0
    80000348:	dec080e7          	jalr	-532(ra) # 80000130 <printf>
    printf(s);
    8000034c:	00048513          	mv	a0,s1
    80000350:	00000097          	auipc	ra,0x0
    80000354:	de0080e7          	jalr	-544(ra) # 80000130 <printf>
    printf("\n");
    80000358:	00002517          	auipc	a0,0x2
    8000035c:	cf050513          	addi	a0,a0,-784 # 80002048 <digits+0x38>
    80000360:	00000097          	auipc	ra,0x0
    80000364:	dd0080e7          	jalr	-560(ra) # 80000130 <printf>
    for (;;)
    80000368:	0000006f          	j	80000368 <panic+0x44>

000000008000036c <main>:
extern void userinit(); // Init process (pid 1)
extern void scheduler(); // Start scheduling

char stack0[4096];
void main()
{
    8000036c:	ff010113          	addi	sp,sp,-16
    80000370:	00113423          	sd	ra,8(sp)
    80000374:	00813023          	sd	s0,0(sp)
    80000378:	01010413          	addi	s0,sp,16
    printf("xv6 kernel is booting\n");
    8000037c:	00002517          	auipc	a0,0x2
    80000380:	cac50513          	addi	a0,a0,-852 # 80002028 <digits+0x18>
    80000384:	00000097          	auipc	ra,0x0
    80000388:	dac080e7          	jalr	-596(ra) # 80000130 <printf>
    kinit();
    8000038c:	00000097          	auipc	ra,0x0
    80000390:	0bc080e7          	jalr	188(ra) # 80000448 <kinit>
    printf("kinit ok\n");
    80000394:	00002517          	auipc	a0,0x2
    80000398:	cac50513          	addi	a0,a0,-852 # 80002040 <digits+0x30>
    8000039c:	00000097          	auipc	ra,0x0
    800003a0:	d94080e7          	jalr	-620(ra) # 80000130 <printf>
    procinit();
    800003a4:	00001097          	auipc	ra,0x1
    800003a8:	3dc080e7          	jalr	988(ra) # 80001780 <procinit>
    printf("procinit ok\n");
    800003ac:	00002517          	auipc	a0,0x2
    800003b0:	ca450513          	addi	a0,a0,-860 # 80002050 <digits+0x40>
    800003b4:	00000097          	auipc	ra,0x0
    800003b8:	d7c080e7          	jalr	-644(ra) # 80000130 <printf>
    trapinit();
    800003bc:	00002097          	auipc	ra,0x2
    800003c0:	8f4080e7          	jalr	-1804(ra) # 80001cb0 <trapinit>
    printf("trapinit ok\n");
    800003c4:	00002517          	auipc	a0,0x2
    800003c8:	c9c50513          	addi	a0,a0,-868 # 80002060 <digits+0x50>
    800003cc:	00000097          	auipc	ra,0x0
    800003d0:	d64080e7          	jalr	-668(ra) # 80000130 <printf>
    plicinit();
    800003d4:	00002097          	auipc	ra,0x2
    800003d8:	a10080e7          	jalr	-1520(ra) # 80001de4 <plicinit>
    printf("plicinit ok\n");
    800003dc:	00002517          	auipc	a0,0x2
    800003e0:	c9450513          	addi	a0,a0,-876 # 80002070 <digits+0x60>
    800003e4:	00000097          	auipc	ra,0x0
    800003e8:	d4c080e7          	jalr	-692(ra) # 80000130 <printf>
    userinit();
    800003ec:	00001097          	auipc	ra,0x1
    800003f0:	654080e7          	jalr	1620(ra) # 80001a40 <userinit>
    printf("userinit ok\n");
    800003f4:	00002517          	auipc	a0,0x2
    800003f8:	c8c50513          	addi	a0,a0,-884 # 80002080 <digits+0x70>
    800003fc:	00000097          	auipc	ra,0x0
    80000400:	d34080e7          	jalr	-716(ra) # 80000130 <printf>
    scheduler();
    80000404:	00013403          	ld	s0,0(sp)
    80000408:	00813083          	ld	ra,8(sp)
    8000040c:	01010113          	addi	sp,sp,16
    scheduler();
    80000410:	00001317          	auipc	t1,0x1
    80000414:	52c30067          	jr	1324(t1) # 8000193c <scheduler>

0000000080000418 <uartputc>:
#include "board.h"
#include "types.h"

void uartputc(uint8_t c)
{
    80000418:	ff010113          	addi	sp,sp,-16
    8000041c:	00813423          	sd	s0,8(sp)
    80000420:	01010413          	addi	s0,sp,16
    while ((*(uint8_t *) TX_READY) & 0x8) ;
    80000424:	406007b7          	lui	a5,0x40600
    80000428:	0087c783          	lbu	a5,8(a5) # 40600008 <_entry-0x3f9ffff8>
    8000042c:	0087f793          	andi	a5,a5,8
    80000430:	00079063          	bnez	a5,80000430 <uartputc+0x18>
    *(uint8_t *)TX_DATA = c;
    80000434:	406007b7          	lui	a5,0x40600
    80000438:	00a78223          	sb	a0,4(a5) # 40600004 <_entry-0x3f9ffffc>
    8000043c:	00813403          	ld	s0,8(sp)
    80000440:	01010113          	addi	sp,sp,16
    80000444:	00008067          	ret

0000000080000448 <kinit>:

struct run *freelist;

void
kinit()
{
    80000448:	fc010113          	addi	sp,sp,-64
    8000044c:	02913423          	sd	s1,40(sp)

void
freerange(void *pa_start, void *pa_end)
{
    char *p;
    p = (char*)PGROUNDUP((uint64_t)pa_start);
    80000450:	fffff7b7          	lui	a5,0xfffff
    80000454:	00004497          	auipc	s1,0x4
    80000458:	0db48493          	addi	s1,s1,219 # 8000452f <end+0xfff>
{
    8000045c:	02813823          	sd	s0,48(sp)
    80000460:	01313c23          	sd	s3,24(sp)
    p = (char*)PGROUNDUP((uint64_t)pa_start);
    80000464:	00f4f4b3          	and	s1,s1,a5
{
    80000468:	02113c23          	sd	ra,56(sp)
    8000046c:	03213023          	sd	s2,32(sp)
    80000470:	01413823          	sd	s4,16(sp)
    80000474:	01513423          	sd	s5,8(sp)
    80000478:	04010413          	addi	s0,sp,64
    for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    8000047c:	000017b7          	lui	a5,0x1
    80000480:	080019b7          	lui	s3,0x8001
    80000484:	00f487b3          	add	a5,s1,a5
    80000488:	00499993          	slli	s3,s3,0x4
    8000048c:	04f9ee63          	bltu	s3,a5,800004e8 <kinit+0xa0>
    80000490:	00003a97          	auipc	s5,0x3
    80000494:	0a0a8a93          	addi	s5,s5,160 # 80003530 <end>
    80000498:	00002917          	auipc	s2,0x2
    8000049c:	d7890913          	addi	s2,s2,-648 # 80002210 <freelist>
kfree(void *pa)
{
    struct run *r;

    if(((uint64_t)pa % PGSIZE) != 0 || (char*)pa < end || (uint64_t)pa >= PHYSTOP)
        panic("kfree");
    800004a0:	00002a17          	auipc	s4,0x2
    800004a4:	bf0a0a13          	addi	s4,s4,-1040 # 80002090 <digits+0x80>
    800004a8:	000a0513          	mv	a0,s4
    if(((uint64_t)pa % PGSIZE) != 0 || (char*)pa < end || (uint64_t)pa >= PHYSTOP)
    800004ac:	0154e463          	bltu	s1,s5,800004b4 <kinit+0x6c>
    800004b0:	0134e663          	bltu	s1,s3,800004bc <kinit+0x74>
        panic("kfree");
    800004b4:	00000097          	auipc	ra,0x0
    800004b8:	e70080e7          	jalr	-400(ra) # 80000324 <panic>

    // Fill with junk to catch dangling refs.
    memset(pa, 1, PGSIZE);
    800004bc:	00048513          	mv	a0,s1
    800004c0:	00001637          	lui	a2,0x1
    800004c4:	00100593          	li	a1,1
    800004c8:	00000097          	auipc	ra,0x0
    800004cc:	204080e7          	jalr	516(ra) # 800006cc <memset>

    r = (struct run*)pa;

    r->next = freelist;
    800004d0:	00093783          	ld	a5,0(s2)
    800004d4:	00f4b023          	sd	a5,0(s1)
    for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800004d8:	000017b7          	lui	a5,0x1
    freelist = r;
    800004dc:	00993023          	sd	s1,0(s2)
    for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800004e0:	00f484b3          	add	s1,s1,a5
    800004e4:	fd3492e3          	bne	s1,s3,800004a8 <kinit+0x60>
}
    800004e8:	03813083          	ld	ra,56(sp)
    800004ec:	03013403          	ld	s0,48(sp)
    800004f0:	02813483          	ld	s1,40(sp)
    800004f4:	02013903          	ld	s2,32(sp)
    800004f8:	01813983          	ld	s3,24(sp)
    800004fc:	01013a03          	ld	s4,16(sp)
    80000500:	00813a83          	ld	s5,8(sp)
    80000504:	04010113          	addi	sp,sp,64
    80000508:	00008067          	ret

000000008000050c <freerange>:
    p = (char*)PGROUNDUP((uint64_t)pa_start);
    8000050c:	000017b7          	lui	a5,0x1
{
    80000510:	fb010113          	addi	sp,sp,-80
    p = (char*)PGROUNDUP((uint64_t)pa_start);
    80000514:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
{
    80000518:	02913c23          	sd	s1,56(sp)
    p = (char*)PGROUNDUP((uint64_t)pa_start);
    8000051c:	00e504b3          	add	s1,a0,a4
    80000520:	fffff737          	lui	a4,0xfffff
{
    80000524:	04813023          	sd	s0,64(sp)
    80000528:	04113423          	sd	ra,72(sp)
    8000052c:	03213823          	sd	s2,48(sp)
    80000530:	03313423          	sd	s3,40(sp)
    80000534:	03413023          	sd	s4,32(sp)
    80000538:	01513c23          	sd	s5,24(sp)
    8000053c:	01613823          	sd	s6,16(sp)
    80000540:	01713423          	sd	s7,8(sp)
    80000544:	05010413          	addi	s0,sp,80
    p = (char*)PGROUNDUP((uint64_t)pa_start);
    80000548:	00e4f4b3          	and	s1,s1,a4
    for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    8000054c:	00f487b3          	add	a5,s1,a5
    80000550:	06f5e863          	bltu	a1,a5,800005c0 <freerange+0xb4>
    if(((uint64_t)pa % PGSIZE) != 0 || (char*)pa < end || (uint64_t)pa >= PHYSTOP)
    80000554:	08001bb7          	lui	s7,0x8001
    80000558:	00058993          	mv	s3,a1
    8000055c:	00003b17          	auipc	s6,0x3
    80000560:	fd4b0b13          	addi	s6,s6,-44 # 80003530 <end>
    80000564:	00002917          	auipc	s2,0x2
    80000568:	cac90913          	addi	s2,s2,-852 # 80002210 <freelist>
        panic("kfree");
    8000056c:	00002a97          	auipc	s5,0x2
    80000570:	b24a8a93          	addi	s5,s5,-1244 # 80002090 <digits+0x80>
    if(((uint64_t)pa % PGSIZE) != 0 || (char*)pa < end || (uint64_t)pa >= PHYSTOP)
    80000574:	004b9b93          	slli	s7,s7,0x4
    for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000578:	00002a37          	lui	s4,0x2
        panic("kfree");
    8000057c:	000a8513          	mv	a0,s5
    if(((uint64_t)pa % PGSIZE) != 0 || (char*)pa < end || (uint64_t)pa >= PHYSTOP)
    80000580:	0164e463          	bltu	s1,s6,80000588 <freerange+0x7c>
    80000584:	0174e663          	bltu	s1,s7,80000590 <freerange+0x84>
        panic("kfree");
    80000588:	00000097          	auipc	ra,0x0
    8000058c:	d9c080e7          	jalr	-612(ra) # 80000324 <panic>
    memset(pa, 1, PGSIZE);
    80000590:	00048513          	mv	a0,s1
    80000594:	00001637          	lui	a2,0x1
    80000598:	00100593          	li	a1,1
    8000059c:	00000097          	auipc	ra,0x0
    800005a0:	130080e7          	jalr	304(ra) # 800006cc <memset>
    r->next = freelist;
    800005a4:	00093703          	ld	a4,0(s2)
    for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800005a8:	014487b3          	add	a5,s1,s4
    r->next = freelist;
    800005ac:	00e4b023          	sd	a4,0(s1)
    freelist = r;
    800005b0:	00993023          	sd	s1,0(s2)
    for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800005b4:	00001737          	lui	a4,0x1
    800005b8:	00e484b3          	add	s1,s1,a4
    800005bc:	fcf9f0e3          	bgeu	s3,a5,8000057c <freerange+0x70>
}
    800005c0:	04813083          	ld	ra,72(sp)
    800005c4:	04013403          	ld	s0,64(sp)
    800005c8:	03813483          	ld	s1,56(sp)
    800005cc:	03013903          	ld	s2,48(sp)
    800005d0:	02813983          	ld	s3,40(sp)
    800005d4:	02013a03          	ld	s4,32(sp)
    800005d8:	01813a83          	ld	s5,24(sp)
    800005dc:	01013b03          	ld	s6,16(sp)
    800005e0:	00813b83          	ld	s7,8(sp)
    800005e4:	05010113          	addi	sp,sp,80
    800005e8:	00008067          	ret

00000000800005ec <kfree>:
{
    800005ec:	fe010113          	addi	sp,sp,-32
    800005f0:	00813823          	sd	s0,16(sp)
    800005f4:	00913423          	sd	s1,8(sp)
    800005f8:	00113c23          	sd	ra,24(sp)
    800005fc:	02010413          	addi	s0,sp,32
    if(((uint64_t)pa % PGSIZE) != 0 || (char*)pa < end || (uint64_t)pa >= PHYSTOP)
    80000600:	03451793          	slli	a5,a0,0x34
{
    80000604:	00050493          	mv	s1,a0
    if(((uint64_t)pa % PGSIZE) != 0 || (char*)pa < end || (uint64_t)pa >= PHYSTOP)
    80000608:	00079863          	bnez	a5,80000618 <kfree+0x2c>
    8000060c:	00003797          	auipc	a5,0x3
    80000610:	f2478793          	addi	a5,a5,-220 # 80003530 <end>
    80000614:	04f57863          	bgeu	a0,a5,80000664 <kfree+0x78>
        panic("kfree");
    80000618:	00002517          	auipc	a0,0x2
    8000061c:	a7850513          	addi	a0,a0,-1416 # 80002090 <digits+0x80>
    80000620:	00000097          	auipc	ra,0x0
    80000624:	d04080e7          	jalr	-764(ra) # 80000324 <panic>
    memset(pa, 1, PGSIZE);
    80000628:	00048513          	mv	a0,s1
    8000062c:	00001637          	lui	a2,0x1
    80000630:	00100593          	li	a1,1
    80000634:	00000097          	auipc	ra,0x0
    80000638:	098080e7          	jalr	152(ra) # 800006cc <memset>
    r->next = freelist;
    8000063c:	00002797          	auipc	a5,0x2
    80000640:	bd478793          	addi	a5,a5,-1068 # 80002210 <freelist>
    80000644:	0007b703          	ld	a4,0(a5)
}
    80000648:	01813083          	ld	ra,24(sp)
    8000064c:	01013403          	ld	s0,16(sp)
    r->next = freelist;
    80000650:	00e4b023          	sd	a4,0(s1)
    freelist = r;
    80000654:	0097b023          	sd	s1,0(a5)
}
    80000658:	00813483          	ld	s1,8(sp)
    8000065c:	02010113          	addi	sp,sp,32
    80000660:	00008067          	ret
    if(((uint64_t)pa % PGSIZE) != 0 || (char*)pa < end || (uint64_t)pa >= PHYSTOP)
    80000664:	080017b7          	lui	a5,0x8001
    80000668:	00479793          	slli	a5,a5,0x4
    8000066c:	faf56ee3          	bltu	a0,a5,80000628 <kfree+0x3c>
    80000670:	fa9ff06f          	j	80000618 <kfree+0x2c>

0000000080000674 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000674:	fe010113          	addi	sp,sp,-32
    80000678:	00813823          	sd	s0,16(sp)
    8000067c:	00913423          	sd	s1,8(sp)
    80000680:	00113c23          	sd	ra,24(sp)
    80000684:	02010413          	addi	s0,sp,32
    struct run *r;

    r = freelist;
    80000688:	00002797          	auipc	a5,0x2
    8000068c:	b8878793          	addi	a5,a5,-1144 # 80002210 <freelist>
    80000690:	0007b483          	ld	s1,0(a5)
    if(r)
    80000694:	02048063          	beqz	s1,800006b4 <kalloc+0x40>
        freelist = r->next;
    80000698:	0004b703          	ld	a4,0(s1)

    if(r)
        memset((char*)r, 5, PGSIZE); // fill with junk
    8000069c:	00001637          	lui	a2,0x1
    800006a0:	00500593          	li	a1,5
    800006a4:	00048513          	mv	a0,s1
        freelist = r->next;
    800006a8:	00e7b023          	sd	a4,0(a5)
        memset((char*)r, 5, PGSIZE); // fill with junk
    800006ac:	00000097          	auipc	ra,0x0
    800006b0:	020080e7          	jalr	32(ra) # 800006cc <memset>
    return (void*)r;
    800006b4:	01813083          	ld	ra,24(sp)
    800006b8:	01013403          	ld	s0,16(sp)
    800006bc:	00048513          	mv	a0,s1
    800006c0:	00813483          	ld	s1,8(sp)
    800006c4:	02010113          	addi	sp,sp,32
    800006c8:	00008067          	ret

00000000800006cc <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint32_t n)
{
    800006cc:	ff010113          	addi	sp,sp,-16
    800006d0:	00813423          	sd	s0,8(sp)
    800006d4:	01010413          	addi	s0,sp,16
    char *cdst = (char *) dst;
    int i;
    for(i = 0; i < n; i++){
    800006d8:	02060263          	beqz	a2,800006fc <memset+0x30>
    800006dc:	02061613          	slli	a2,a2,0x20
    800006e0:	02065613          	srli	a2,a2,0x20
        cdst[i] = c;
    800006e4:	0ff5f593          	zext.b	a1,a1
    800006e8:	00050793          	mv	a5,a0
    800006ec:	00a60733          	add	a4,a2,a0
    800006f0:	00b78023          	sb	a1,0(a5)
    for(i = 0; i < n; i++){
    800006f4:	00178793          	addi	a5,a5,1
    800006f8:	fee79ce3          	bne	a5,a4,800006f0 <memset+0x24>
    }
    return dst;
}
    800006fc:	00813403          	ld	s0,8(sp)
    80000700:	01010113          	addi	sp,sp,16
    80000704:	00008067          	ret

0000000080000708 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32_t n)
{
    80000708:	ff010113          	addi	sp,sp,-16
    8000070c:	00813423          	sd	s0,8(sp)
    80000710:	01010413          	addi	s0,sp,16
    const uint8_t *s1, *s2;

    s1 = v1;
    s2 = v2;
    while(n-- > 0){
    80000714:	02060e63          	beqz	a2,80000750 <memcmp+0x48>
    80000718:	02061613          	slli	a2,a2,0x20
    8000071c:	02065613          	srli	a2,a2,0x20
    80000720:	00c586b3          	add	a3,a1,a2
    80000724:	0080006f          	j	8000072c <memcmp+0x24>
    80000728:	02b68463          	beq	a3,a1,80000750 <memcmp+0x48>
        if(*s1 != *s2)
    8000072c:	00054783          	lbu	a5,0(a0)
    80000730:	0005c703          	lbu	a4,0(a1)
        return *s1 - *s2;
        s1++, s2++;
    80000734:	00150513          	addi	a0,a0,1
    80000738:	00158593          	addi	a1,a1,1
        if(*s1 != *s2)
    8000073c:	fee786e3          	beq	a5,a4,80000728 <memcmp+0x20>
    }

    return 0;
}
    80000740:	00813403          	ld	s0,8(sp)
        return *s1 - *s2;
    80000744:	40e7853b          	subw	a0,a5,a4
}
    80000748:	01010113          	addi	sp,sp,16
    8000074c:	00008067          	ret
    80000750:	00813403          	ld	s0,8(sp)
    return 0;
    80000754:	00000513          	li	a0,0
}
    80000758:	01010113          	addi	sp,sp,16
    8000075c:	00008067          	ret

0000000080000760 <memmove>:

void*
memmove(void *dst, const void *src, uint32_t n)
{
    80000760:	ff010113          	addi	sp,sp,-16
    80000764:	00813423          	sd	s0,8(sp)
    80000768:	01010413          	addi	s0,sp,16
    const char *s;
    char *d;

    if(n == 0)
    8000076c:	02060863          	beqz	a2,8000079c <memmove+0x3c>
        return dst;
    
    s = src;
    d = dst;
    if(s < d && s + n > d){
    80000770:	02061793          	slli	a5,a2,0x20
        s += n;
        d += n;
        while(n-- > 0)
        *--d = *--s;
    } else
        while(n-- > 0)
    80000774:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    if(s < d && s + n > d){
    80000778:	0207d793          	srli	a5,a5,0x20
    8000077c:	02a5e663          	bltu	a1,a0,800007a8 <memmove+0x48>
    80000780:	00f587b3          	add	a5,a1,a5
{
    80000784:	00050713          	mv	a4,a0
        *d++ = *s++;
    80000788:	0005c683          	lbu	a3,0(a1)
    8000078c:	00158593          	addi	a1,a1,1
    80000790:	00170713          	addi	a4,a4,1 # 1001 <_entry-0x7fffefff>
    80000794:	fed70fa3          	sb	a3,-1(a4)
        while(n-- > 0)
    80000798:	fef598e3          	bne	a1,a5,80000788 <memmove+0x28>

    return dst;
}
    8000079c:	00813403          	ld	s0,8(sp)
    800007a0:	01010113          	addi	sp,sp,16
    800007a4:	00008067          	ret
    if(s < d && s + n > d){
    800007a8:	00f58733          	add	a4,a1,a5
    800007ac:	fce57ae3          	bgeu	a0,a4,80000780 <memmove+0x20>
        d += n;
    800007b0:	02069693          	slli	a3,a3,0x20
    800007b4:	0206d693          	srli	a3,a3,0x20
    800007b8:	fff6c693          	not	a3,a3
    800007bc:	00f507b3          	add	a5,a0,a5
        while(n-- > 0)
    800007c0:	00d706b3          	add	a3,a4,a3
        *--d = *--s;
    800007c4:	fff74603          	lbu	a2,-1(a4)
    800007c8:	fff70713          	addi	a4,a4,-1
    800007cc:	fff78793          	addi	a5,a5,-1
    800007d0:	00c78023          	sb	a2,0(a5)
        while(n-- > 0)
    800007d4:	fee698e3          	bne	a3,a4,800007c4 <memmove+0x64>
}
    800007d8:	00813403          	ld	s0,8(sp)
    800007dc:	01010113          	addi	sp,sp,16
    800007e0:	00008067          	ret

00000000800007e4 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint32_t n)
{
    800007e4:	ff010113          	addi	sp,sp,-16
    800007e8:	00813423          	sd	s0,8(sp)
    800007ec:	01010413          	addi	s0,sp,16
    return memmove(dst, src, n);
}
    800007f0:	00813403          	ld	s0,8(sp)
    800007f4:	01010113          	addi	sp,sp,16
    return memmove(dst, src, n);
    800007f8:	00000317          	auipc	t1,0x0
    800007fc:	f6830067          	jr	-152(t1) # 80000760 <memmove>

0000000080000800 <strncmp>:

int
strncmp(const char *p, const char *q, uint32_t n)
{
    80000800:	ff010113          	addi	sp,sp,-16
    80000804:	00813423          	sd	s0,8(sp)
    80000808:	01010413          	addi	s0,sp,16
    while(n > 0 && *p && *p == *q)
    8000080c:	04060063          	beqz	a2,8000084c <strncmp+0x4c>
    80000810:	02061613          	slli	a2,a2,0x20
    80000814:	02065613          	srli	a2,a2,0x20
    80000818:	00c586b3          	add	a3,a1,a2
    8000081c:	0100006f          	j	8000082c <strncmp+0x2c>
        n--, p++, q++;
    80000820:	00150513          	addi	a0,a0,1
    while(n > 0 && *p && *p == *q)
    80000824:	00e79c63          	bne	a5,a4,8000083c <strncmp+0x3c>
    80000828:	02d58263          	beq	a1,a3,8000084c <strncmp+0x4c>
    8000082c:	00054783          	lbu	a5,0(a0)
        n--, p++, q++;
    80000830:	00158593          	addi	a1,a1,1
    while(n > 0 && *p && *p == *q)
    80000834:	fff5c703          	lbu	a4,-1(a1)
    80000838:	fe0794e3          	bnez	a5,80000820 <strncmp+0x20>
    if(n == 0)
        return 0;
    return (uint8_t)*p - (uint8_t)*q;
}
    8000083c:	00813403          	ld	s0,8(sp)
    return (uint8_t)*p - (uint8_t)*q;
    80000840:	40e7853b          	subw	a0,a5,a4
}
    80000844:	01010113          	addi	sp,sp,16
    80000848:	00008067          	ret
    8000084c:	00813403          	ld	s0,8(sp)
        return 0;
    80000850:	00000513          	li	a0,0
}
    80000854:	01010113          	addi	sp,sp,16
    80000858:	00008067          	ret

000000008000085c <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    8000085c:	ff010113          	addi	sp,sp,-16
    80000860:	00813423          	sd	s0,8(sp)
    80000864:	01010413          	addi	s0,sp,16
    char *os;

    os = s;
    while(n-- > 0 && (*s++ = *t++) != 0)
    80000868:	00050713          	mv	a4,a0
    8000086c:	0180006f          	j	80000884 <strncpy+0x28>
    80000870:	0005c783          	lbu	a5,0(a1)
    80000874:	00170713          	addi	a4,a4,1
    80000878:	00158593          	addi	a1,a1,1
    8000087c:	fef70fa3          	sb	a5,-1(a4)
    80000880:	00078863          	beqz	a5,80000890 <strncpy+0x34>
    80000884:	00060813          	mv	a6,a2
    80000888:	fff6061b          	addiw	a2,a2,-1
    8000088c:	ff0042e3          	bgtz	a6,80000870 <strncpy+0x14>
        ;
    while(n-- > 0)
    80000890:	00070693          	mv	a3,a4
    80000894:	00c05e63          	blez	a2,800008b0 <strncpy+0x54>
        *s++ = 0;
    80000898:	00168693          	addi	a3,a3,1
    8000089c:	40d707bb          	subw	a5,a4,a3
    800008a0:	fff7879b          	addiw	a5,a5,-1
    while(n-- > 0)
    800008a4:	010787bb          	addw	a5,a5,a6
        *s++ = 0;
    800008a8:	fe068fa3          	sb	zero,-1(a3)
    while(n-- > 0)
    800008ac:	fef046e3          	bgtz	a5,80000898 <strncpy+0x3c>
    return os;
}
    800008b0:	00813403          	ld	s0,8(sp)
    800008b4:	01010113          	addi	sp,sp,16
    800008b8:	00008067          	ret

00000000800008bc <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800008bc:	ff010113          	addi	sp,sp,-16
    800008c0:	00813423          	sd	s0,8(sp)
    800008c4:	01010413          	addi	s0,sp,16
    char *os;

    os = s;
    if(n <= 0)
    800008c8:	02c05a63          	blez	a2,800008fc <safestrcpy+0x40>
    800008cc:	fff6069b          	addiw	a3,a2,-1
    800008d0:	02069693          	slli	a3,a3,0x20
    800008d4:	0206d693          	srli	a3,a3,0x20
    800008d8:	00d586b3          	add	a3,a1,a3
    800008dc:	00050793          	mv	a5,a0
        return os;
    while(--n > 0 && (*s++ = *t++) != 0)
    800008e0:	00d58c63          	beq	a1,a3,800008f8 <safestrcpy+0x3c>
    800008e4:	0005c703          	lbu	a4,0(a1)
    800008e8:	00178793          	addi	a5,a5,1
    800008ec:	00158593          	addi	a1,a1,1
    800008f0:	fee78fa3          	sb	a4,-1(a5)
    800008f4:	fe0716e3          	bnez	a4,800008e0 <safestrcpy+0x24>
        ;
    *s = 0;
    800008f8:	00078023          	sb	zero,0(a5)
    return os;
}
    800008fc:	00813403          	ld	s0,8(sp)
    80000900:	01010113          	addi	sp,sp,16
    80000904:	00008067          	ret

0000000080000908 <strlen>:

int
strlen(const char *s)
{
    80000908:	ff010113          	addi	sp,sp,-16
    8000090c:	00813423          	sd	s0,8(sp)
    80000910:	01010413          	addi	s0,sp,16
    int n;

    for(n = 0; s[n]; n++)
    80000914:	00054783          	lbu	a5,0(a0)
    80000918:	02078463          	beqz	a5,80000940 <strlen+0x38>
    8000091c:	00150793          	addi	a5,a0,1
    80000920:	40a006bb          	negw	a3,a0
    80000924:	0007c703          	lbu	a4,0(a5)
    80000928:	00f6853b          	addw	a0,a3,a5
    8000092c:	00178793          	addi	a5,a5,1
    80000930:	fe071ae3          	bnez	a4,80000924 <strlen+0x1c>
        ;
    return n;
}
    80000934:	00813403          	ld	s0,8(sp)
    80000938:	01010113          	addi	sp,sp,16
    8000093c:	00008067          	ret
    80000940:	00813403          	ld	s0,8(sp)
    for(n = 0; s[n]; n++)
    80000944:	00000513          	li	a0,0
}
    80000948:	01010113          	addi	sp,sp,16
    8000094c:	00008067          	ret

0000000080000950 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64_t va, int alloc)
{
    80000950:	fc010113          	addi	sp,sp,-64
    80000954:	02813823          	sd	s0,48(sp)
    80000958:	03213023          	sd	s2,32(sp)
    8000095c:	01313c23          	sd	s3,24(sp)
    80000960:	01513423          	sd	s5,8(sp)
    80000964:	02113c23          	sd	ra,56(sp)
    80000968:	02913423          	sd	s1,40(sp)
    8000096c:	01413823          	sd	s4,16(sp)
    80000970:	01613023          	sd	s6,0(sp)
    80000974:	04010413          	addi	s0,sp,64
    if (va >= MAXVA)
    80000978:	fff00793          	li	a5,-1
    8000097c:	01a7d793          	srli	a5,a5,0x1a
{
    80000980:	00058a93          	mv	s5,a1
    80000984:	00050913          	mv	s2,a0
    80000988:	00060993          	mv	s3,a2
    if (va >= MAXVA)
    8000098c:	0ab7ee63          	bltu	a5,a1,80000a48 <walk+0xf8>
{
    80000990:	00200b13          	li	s6,2
    80000994:	00200793          	li	a5,2
        panic("walk");

    for (int level = 2; level > 0; level--)
    80000998:	00100a13          	li	s4,1
    {
        pte_t *pte = &pagetable[PX(level, va)];
    8000099c:	0037949b          	slliw	s1,a5,0x3
    800009a0:	00f484bb          	addw	s1,s1,a5
    800009a4:	00c4849b          	addiw	s1,s1,12
    800009a8:	009ad4b3          	srl	s1,s5,s1
    800009ac:	1ff4f493          	andi	s1,s1,511
    800009b0:	00349493          	slli	s1,s1,0x3
    800009b4:	009904b3          	add	s1,s2,s1
        if (*pte & PTE_V)
    800009b8:	0004b903          	ld	s2,0(s1)
    800009bc:	00197793          	andi	a5,s2,1
        {
            pagetable = (pagetable_t)PTE2PA(*pte);
    800009c0:	00a95913          	srli	s2,s2,0xa
    800009c4:	00c91913          	slli	s2,s2,0xc
        if (*pte & PTE_V)
    800009c8:	02079c63          	bnez	a5,80000a00 <walk+0xb0>
        }
        else
        {
            if (!alloc || (pagetable = (uint64_t *)kalloc()) == 0)
    800009cc:	08098863          	beqz	s3,80000a5c <walk+0x10c>
    800009d0:	00000097          	auipc	ra,0x0
    800009d4:	ca4080e7          	jalr	-860(ra) # 80000674 <kalloc>
                return 0;
            memset(pagetable, 0, PGSIZE);
    800009d8:	00001637          	lui	a2,0x1
    800009dc:	00000593          	li	a1,0
            if (!alloc || (pagetable = (uint64_t *)kalloc()) == 0)
    800009e0:	00050913          	mv	s2,a0
    800009e4:	06050c63          	beqz	a0,80000a5c <walk+0x10c>
            memset(pagetable, 0, PGSIZE);
    800009e8:	00000097          	auipc	ra,0x0
    800009ec:	ce4080e7          	jalr	-796(ra) # 800006cc <memset>
            *pte = PA2PTE(pagetable) | PTE_V;
    800009f0:	00c95793          	srli	a5,s2,0xc
    800009f4:	00a79793          	slli	a5,a5,0xa
    800009f8:	0017e793          	ori	a5,a5,1
    800009fc:	00f4b023          	sd	a5,0(s1)
    for (int level = 2; level > 0; level--)
    80000a00:	00100793          	li	a5,1
    80000a04:	034b1e63          	bne	s6,s4,80000a40 <walk+0xf0>
        }
    }
    return &pagetable[PX(0, va)];
    80000a08:	00cada93          	srli	s5,s5,0xc
    80000a0c:	1ffafa93          	andi	s5,s5,511
    80000a10:	003a9a93          	slli	s5,s5,0x3
    80000a14:	01590533          	add	a0,s2,s5
}
    80000a18:	03813083          	ld	ra,56(sp)
    80000a1c:	03013403          	ld	s0,48(sp)
    80000a20:	02813483          	ld	s1,40(sp)
    80000a24:	02013903          	ld	s2,32(sp)
    80000a28:	01813983          	ld	s3,24(sp)
    80000a2c:	01013a03          	ld	s4,16(sp)
    80000a30:	00813a83          	ld	s5,8(sp)
    80000a34:	00013b03          	ld	s6,0(sp)
    80000a38:	04010113          	addi	sp,sp,64
    80000a3c:	00008067          	ret
    80000a40:	00100b13          	li	s6,1
    80000a44:	f59ff06f          	j	8000099c <walk+0x4c>
        panic("walk");
    80000a48:	00001517          	auipc	a0,0x1
    80000a4c:	65050513          	addi	a0,a0,1616 # 80002098 <digits+0x88>
    80000a50:	00000097          	auipc	ra,0x0
    80000a54:	8d4080e7          	jalr	-1836(ra) # 80000324 <panic>
    80000a58:	f39ff06f          	j	80000990 <walk+0x40>
                return 0;
    80000a5c:	00000513          	li	a0,0
    80000a60:	fb9ff06f          	j	80000a18 <walk+0xc8>

0000000080000a64 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64_t va)
{
    pte_t *pte;
    uint64_t pa;

    if (va >= MAXVA)
    80000a64:	fff00793          	li	a5,-1
    80000a68:	01a7d793          	srli	a5,a5,0x1a
    80000a6c:	00b7f663          	bgeu	a5,a1,80000a78 <walkaddr+0x14>
        return 0;
    80000a70:	00000513          	li	a0,0
        return 0;
    if ((*pte & PTE_U) == 0)
        return 0;
    pa = PTE2PA(*pte);
    return pa;
}
    80000a74:	00008067          	ret
{
    80000a78:	ff010113          	addi	sp,sp,-16
    80000a7c:	00813023          	sd	s0,0(sp)
    80000a80:	00113423          	sd	ra,8(sp)
    80000a84:	01010413          	addi	s0,sp,16
    pte = walk(pagetable, va, 0);
    80000a88:	00000613          	li	a2,0
    80000a8c:	00000097          	auipc	ra,0x0
    80000a90:	ec4080e7          	jalr	-316(ra) # 80000950 <walk>
    if (pte == 0)
    80000a94:	00050a63          	beqz	a0,80000aa8 <walkaddr+0x44>
    if ((*pte & PTE_V) == 0)
    80000a98:	00053503          	ld	a0,0(a0)
    if ((*pte & PTE_U) == 0)
    80000a9c:	01100793          	li	a5,17
    80000aa0:	01157713          	andi	a4,a0,17
    80000aa4:	00f70c63          	beq	a4,a5,80000abc <walkaddr+0x58>
}
    80000aa8:	00813083          	ld	ra,8(sp)
    80000aac:	00013403          	ld	s0,0(sp)
        return 0;
    80000ab0:	00000513          	li	a0,0
}
    80000ab4:	01010113          	addi	sp,sp,16
    80000ab8:	00008067          	ret
    80000abc:	00813083          	ld	ra,8(sp)
    80000ac0:	00013403          	ld	s0,0(sp)
    pa = PTE2PA(*pte);
    80000ac4:	00a55513          	srli	a0,a0,0xa
    80000ac8:	00c51513          	slli	a0,a0,0xc
}
    80000acc:	01010113          	addi	sp,sp,16
    80000ad0:	00008067          	ret

0000000080000ad4 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int mappages(pagetable_t pagetable, uint64_t va, uint64_t size, uint64_t pa, int perm)
{
    80000ad4:	fa010113          	addi	sp,sp,-96
    80000ad8:	04813823          	sd	s0,80(sp)
    80000adc:	04913423          	sd	s1,72(sp)
    80000ae0:	05213023          	sd	s2,64(sp)
    80000ae4:	03413823          	sd	s4,48(sp)
    80000ae8:	03513423          	sd	s5,40(sp)
    80000aec:	01913423          	sd	s9,8(sp)
    80000af0:	04113c23          	sd	ra,88(sp)
    80000af4:	03313c23          	sd	s3,56(sp)
    80000af8:	03613023          	sd	s6,32(sp)
    80000afc:	01713c23          	sd	s7,24(sp)
    80000b00:	01813823          	sd	s8,16(sp)
    80000b04:	06010413          	addi	s0,sp,96
    80000b08:	00060493          	mv	s1,a2
    80000b0c:	00050a13          	mv	s4,a0
    80000b10:	00058c93          	mv	s9,a1
    80000b14:	00068913          	mv	s2,a3
    80000b18:	00070a93          	mv	s5,a4
    uint64_t a, last;
    pte_t *pte;

    if (size == 0)
    80000b1c:	0c060c63          	beqz	a2,80000bf4 <mappages+0x120>
        panic("mappages: size");

    a = PGROUNDDOWN(va);
    80000b20:	fffff7b7          	lui	a5,0xfffff
    last = PGROUNDDOWN(va + size - 1);
    80000b24:	fffc8993          	addi	s3,s9,-1
    80000b28:	009989b3          	add	s3,s3,s1
    a = PGROUNDDOWN(va);
    80000b2c:	00fcfcb3          	and	s9,s9,a5
    last = PGROUNDDOWN(va + size - 1);
    80000b30:	00f9f9b3          	and	s3,s3,a5
    80000b34:	41990933          	sub	s2,s2,s9
    for (;;)
    {
        if ((pte = walk(pagetable, a, 1)) == 0)
            return -1;
        if (*pte & PTE_V)
            panic("mappages: remap");
    80000b38:	00001b97          	auipc	s7,0x1
    80000b3c:	578b8b93          	addi	s7,s7,1400 # 800020b0 <digits+0xa0>
        *pte = PA2PTE(pa) | perm | PTE_V;
        if (a == last)
            break;
        a += PGSIZE;
    80000b40:	00001b37          	lui	s6,0x1
    80000b44:	0200006f          	j	80000b64 <mappages+0x90>
        *pte = PA2PTE(pa) | perm | PTE_V;
    80000b48:	00c4d493          	srli	s1,s1,0xc
    80000b4c:	00a49493          	slli	s1,s1,0xa
    80000b50:	0154e4b3          	or	s1,s1,s5
    80000b54:	0014e493          	ori	s1,s1,1
    80000b58:	009c3023          	sd	s1,0(s8)
        if (a == last)
    80000b5c:	053c8c63          	beq	s9,s3,80000bb4 <mappages+0xe0>
        a += PGSIZE;
    80000b60:	016c8cb3          	add	s9,s9,s6
        if ((pte = walk(pagetable, a, 1)) == 0)
    80000b64:	000c8593          	mv	a1,s9
    80000b68:	00100613          	li	a2,1
    80000b6c:	000a0513          	mv	a0,s4
    80000b70:	00000097          	auipc	ra,0x0
    80000b74:	de0080e7          	jalr	-544(ra) # 80000950 <walk>
    80000b78:	00050c13          	mv	s8,a0
    80000b7c:	019904b3          	add	s1,s2,s9
    80000b80:	02050e63          	beqz	a0,80000bbc <mappages+0xe8>
        if (*pte & PTE_V)
    80000b84:	00053783          	ld	a5,0(a0)
    80000b88:	0017f793          	andi	a5,a5,1
    80000b8c:	fa078ee3          	beqz	a5,80000b48 <mappages+0x74>
        *pte = PA2PTE(pa) | perm | PTE_V;
    80000b90:	00c4d493          	srli	s1,s1,0xc
    80000b94:	00a49493          	slli	s1,s1,0xa
    80000b98:	0154e4b3          	or	s1,s1,s5
            panic("mappages: remap");
    80000b9c:	000b8513          	mv	a0,s7
        *pte = PA2PTE(pa) | perm | PTE_V;
    80000ba0:	0014e493          	ori	s1,s1,1
            panic("mappages: remap");
    80000ba4:	fffff097          	auipc	ra,0xfffff
    80000ba8:	780080e7          	jalr	1920(ra) # 80000324 <panic>
        *pte = PA2PTE(pa) | perm | PTE_V;
    80000bac:	009c3023          	sd	s1,0(s8)
        if (a == last)
    80000bb0:	fb3c98e3          	bne	s9,s3,80000b60 <mappages+0x8c>
        pa += PGSIZE;
    }
    return 0;
    80000bb4:	00000513          	li	a0,0
    80000bb8:	0080006f          	j	80000bc0 <mappages+0xec>
            return -1;
    80000bbc:	fff00513          	li	a0,-1
}
    80000bc0:	05813083          	ld	ra,88(sp)
    80000bc4:	05013403          	ld	s0,80(sp)
    80000bc8:	04813483          	ld	s1,72(sp)
    80000bcc:	04013903          	ld	s2,64(sp)
    80000bd0:	03813983          	ld	s3,56(sp)
    80000bd4:	03013a03          	ld	s4,48(sp)
    80000bd8:	02813a83          	ld	s5,40(sp)
    80000bdc:	02013b03          	ld	s6,32(sp)
    80000be0:	01813b83          	ld	s7,24(sp)
    80000be4:	01013c03          	ld	s8,16(sp)
    80000be8:	00813c83          	ld	s9,8(sp)
    80000bec:	06010113          	addi	sp,sp,96
    80000bf0:	00008067          	ret
        panic("mappages: size");
    80000bf4:	00001517          	auipc	a0,0x1
    80000bf8:	4ac50513          	addi	a0,a0,1196 # 800020a0 <digits+0x90>
    80000bfc:	fffff097          	auipc	ra,0xfffff
    80000c00:	728080e7          	jalr	1832(ra) # 80000324 <panic>
    80000c04:	f1dff06f          	j	80000b20 <mappages+0x4c>

0000000080000c08 <kvmmap>:
{
    80000c08:	ff010113          	addi	sp,sp,-16
    80000c0c:	00813023          	sd	s0,0(sp)
    80000c10:	00113423          	sd	ra,8(sp)
    80000c14:	01010413          	addi	s0,sp,16
    80000c18:	00060793          	mv	a5,a2
    if (mappages(kpgtbl, va, sz, pa, perm) != 0)
    80000c1c:	00068613          	mv	a2,a3
    80000c20:	00078693          	mv	a3,a5
    80000c24:	00000097          	auipc	ra,0x0
    80000c28:	eb0080e7          	jalr	-336(ra) # 80000ad4 <mappages>
    80000c2c:	00051a63          	bnez	a0,80000c40 <kvmmap+0x38>
}
    80000c30:	00813083          	ld	ra,8(sp)
    80000c34:	00013403          	ld	s0,0(sp)
    80000c38:	01010113          	addi	sp,sp,16
    80000c3c:	00008067          	ret
    80000c40:	00013403          	ld	s0,0(sp)
    80000c44:	00813083          	ld	ra,8(sp)
        panic("kvmmap");
    80000c48:	00001517          	auipc	a0,0x1
    80000c4c:	47850513          	addi	a0,a0,1144 # 800020c0 <digits+0xb0>
}
    80000c50:	01010113          	addi	sp,sp,16
        panic("kvmmap");
    80000c54:	fffff317          	auipc	t1,0xfffff
    80000c58:	6d030067          	jr	1744(t1) # 80000324 <panic>

0000000080000c5c <uvmunmap>:

// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void uvmunmap(pagetable_t pagetable, uint64_t va, uint64_t npages, int do_free)
{
    80000c5c:	fa010113          	addi	sp,sp,-96
    80000c60:	04813823          	sd	s0,80(sp)
    80000c64:	05213023          	sd	s2,64(sp)
    80000c68:	03313c23          	sd	s3,56(sp)
    80000c6c:	03413823          	sd	s4,48(sp)
    80000c70:	01a13023          	sd	s10,0(sp)
    80000c74:	04113c23          	sd	ra,88(sp)
    80000c78:	04913423          	sd	s1,72(sp)
    80000c7c:	03513423          	sd	s5,40(sp)
    80000c80:	03613023          	sd	s6,32(sp)
    80000c84:	01713c23          	sd	s7,24(sp)
    80000c88:	01813823          	sd	s8,16(sp)
    80000c8c:	01913423          	sd	s9,8(sp)
    80000c90:	06010413          	addi	s0,sp,96
    uint64_t a;
    pte_t *pte;

    if ((va % PGSIZE) != 0)
    80000c94:	03459793          	slli	a5,a1,0x34
{
    80000c98:	00058d13          	mv	s10,a1
    80000c9c:	00050993          	mv	s3,a0
    80000ca0:	00060913          	mv	s2,a2
    80000ca4:	00068a13          	mv	s4,a3
    if ((va % PGSIZE) != 0)
    80000ca8:	0e079a63          	bnez	a5,80000d9c <uvmunmap+0x140>
        panic("uvmunmap: not aligned");

    for (a = va; a < va + npages * PGSIZE; a += PGSIZE)
    80000cac:	00c91913          	slli	s2,s2,0xc
    80000cb0:	01a90933          	add	s2,s2,s10
    80000cb4:	072d7263          	bgeu	s10,s2,80000d18 <uvmunmap+0xbc>
    {
        if ((pte = walk(pagetable, a, 0)) == 0)
            panic("uvmunmap: walk");
    80000cb8:	00001c97          	auipc	s9,0x1
    80000cbc:	428c8c93          	addi	s9,s9,1064 # 800020e0 <digits+0xd0>
        if ((*pte & PTE_V) == 0)
            panic("uvmunmap: not mapped");
    80000cc0:	00001b97          	auipc	s7,0x1
    80000cc4:	430b8b93          	addi	s7,s7,1072 # 800020f0 <digits+0xe0>
        if (PTE_FLAGS(*pte) == PTE_V)
    80000cc8:	00100b13          	li	s6,1
            panic("uvmunmap: not a leaf");
    80000ccc:	00001c17          	auipc	s8,0x1
    80000cd0:	43cc0c13          	addi	s8,s8,1084 # 80002108 <digits+0xf8>
    for (a = va; a < va + npages * PGSIZE; a += PGSIZE)
    80000cd4:	00001ab7          	lui	s5,0x1
        if ((pte = walk(pagetable, a, 0)) == 0)
    80000cd8:	000d0593          	mv	a1,s10
    80000cdc:	00000613          	li	a2,0
    80000ce0:	00098513          	mv	a0,s3
    80000ce4:	00000097          	auipc	ra,0x0
    80000ce8:	c6c080e7          	jalr	-916(ra) # 80000950 <walk>
    80000cec:	00050493          	mv	s1,a0
    for (a = va; a < va + npages * PGSIZE; a += PGSIZE)
    80000cf0:	015d0d33          	add	s10,s10,s5
        if ((pte = walk(pagetable, a, 0)) == 0)
    80000cf4:	08050c63          	beqz	a0,80000d8c <uvmunmap+0x130>
        if ((*pte & PTE_V) == 0)
    80000cf8:	0004b783          	ld	a5,0(s1)
    80000cfc:	0017f713          	andi	a4,a5,1
    80000d00:	06070c63          	beqz	a4,80000d78 <uvmunmap+0x11c>
        if (PTE_FLAGS(*pte) == PTE_V)
    80000d04:	3ff7f793          	andi	a5,a5,1023
    80000d08:	05678463          	beq	a5,s6,80000d50 <uvmunmap+0xf4>
        if (do_free)
    80000d0c:	040a1a63          	bnez	s4,80000d60 <uvmunmap+0x104>
        {
            uint64_t pa = PTE2PA(*pte);
            kfree((void *)pa);
        }
        *pte = 0;
    80000d10:	0004b023          	sd	zero,0(s1)
    for (a = va; a < va + npages * PGSIZE; a += PGSIZE)
    80000d14:	fd2d62e3          	bltu	s10,s2,80000cd8 <uvmunmap+0x7c>
    }
}
    80000d18:	05813083          	ld	ra,88(sp)
    80000d1c:	05013403          	ld	s0,80(sp)
    80000d20:	04813483          	ld	s1,72(sp)
    80000d24:	04013903          	ld	s2,64(sp)
    80000d28:	03813983          	ld	s3,56(sp)
    80000d2c:	03013a03          	ld	s4,48(sp)
    80000d30:	02813a83          	ld	s5,40(sp)
    80000d34:	02013b03          	ld	s6,32(sp)
    80000d38:	01813b83          	ld	s7,24(sp)
    80000d3c:	01013c03          	ld	s8,16(sp)
    80000d40:	00813c83          	ld	s9,8(sp)
    80000d44:	00013d03          	ld	s10,0(sp)
    80000d48:	06010113          	addi	sp,sp,96
    80000d4c:	00008067          	ret
            panic("uvmunmap: not a leaf");
    80000d50:	000c0513          	mv	a0,s8
    80000d54:	fffff097          	auipc	ra,0xfffff
    80000d58:	5d0080e7          	jalr	1488(ra) # 80000324 <panic>
        if (do_free)
    80000d5c:	fa0a0ae3          	beqz	s4,80000d10 <uvmunmap+0xb4>
            uint64_t pa = PTE2PA(*pte);
    80000d60:	0004b503          	ld	a0,0(s1)
    80000d64:	00a55513          	srli	a0,a0,0xa
            kfree((void *)pa);
    80000d68:	00c51513          	slli	a0,a0,0xc
    80000d6c:	00000097          	auipc	ra,0x0
    80000d70:	880080e7          	jalr	-1920(ra) # 800005ec <kfree>
    80000d74:	f9dff06f          	j	80000d10 <uvmunmap+0xb4>
            panic("uvmunmap: not mapped");
    80000d78:	000b8513          	mv	a0,s7
    80000d7c:	fffff097          	auipc	ra,0xfffff
    80000d80:	5a8080e7          	jalr	1448(ra) # 80000324 <panic>
        if (PTE_FLAGS(*pte) == PTE_V)
    80000d84:	0004b783          	ld	a5,0(s1)
    80000d88:	f7dff06f          	j	80000d04 <uvmunmap+0xa8>
            panic("uvmunmap: walk");
    80000d8c:	000c8513          	mv	a0,s9
    80000d90:	fffff097          	auipc	ra,0xfffff
    80000d94:	594080e7          	jalr	1428(ra) # 80000324 <panic>
    80000d98:	f61ff06f          	j	80000cf8 <uvmunmap+0x9c>
        panic("uvmunmap: not aligned");
    80000d9c:	00001517          	auipc	a0,0x1
    80000da0:	32c50513          	addi	a0,a0,812 # 800020c8 <digits+0xb8>
    80000da4:	fffff097          	auipc	ra,0xfffff
    80000da8:	580080e7          	jalr	1408(ra) # 80000324 <panic>
    80000dac:	f01ff06f          	j	80000cac <uvmunmap+0x50>

0000000080000db0 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80000db0:	fe010113          	addi	sp,sp,-32
    80000db4:	00813823          	sd	s0,16(sp)
    80000db8:	00913423          	sd	s1,8(sp)
    80000dbc:	00113c23          	sd	ra,24(sp)
    80000dc0:	02010413          	addi	s0,sp,32
    pagetable_t pagetable;
    pagetable = (pagetable_t)kalloc();
    80000dc4:	00000097          	auipc	ra,0x0
    80000dc8:	8b0080e7          	jalr	-1872(ra) # 80000674 <kalloc>
    80000dcc:	00050493          	mv	s1,a0
    if (pagetable == 0)
    80000dd0:	00050a63          	beqz	a0,80000de4 <uvmcreate+0x34>
        return 0;
    memset(pagetable, 0, PGSIZE);
    80000dd4:	00001637          	lui	a2,0x1
    80000dd8:	00000593          	li	a1,0
    80000ddc:	00000097          	auipc	ra,0x0
    80000de0:	8f0080e7          	jalr	-1808(ra) # 800006cc <memset>
    return pagetable;
}
    80000de4:	01813083          	ld	ra,24(sp)
    80000de8:	01013403          	ld	s0,16(sp)
    80000dec:	00048513          	mv	a0,s1
    80000df0:	00813483          	ld	s1,8(sp)
    80000df4:	02010113          	addi	sp,sp,32
    80000df8:	00008067          	ret

0000000080000dfc <uvmfirst>:

// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void uvmfirst(pagetable_t pagetable, char *src, uint32_t sz)
{
    80000dfc:	fd010113          	addi	sp,sp,-48
    80000e00:	02813023          	sd	s0,32(sp)
    80000e04:	01213823          	sd	s2,16(sp)
    80000e08:	01313423          	sd	s3,8(sp)
    80000e0c:	01413023          	sd	s4,0(sp)
    80000e10:	02113423          	sd	ra,40(sp)
    80000e14:	00913c23          	sd	s1,24(sp)
    80000e18:	03010413          	addi	s0,sp,48
    char *mem;

    if (sz >= PGSIZE)
    80000e1c:	000017b7          	lui	a5,0x1
{
    80000e20:	00060913          	mv	s2,a2
    80000e24:	00050a13          	mv	s4,a0
    80000e28:	00058993          	mv	s3,a1
    if (sz >= PGSIZE)
    80000e2c:	06f67663          	bgeu	a2,a5,80000e98 <uvmfirst+0x9c>
        panic("uvmfirst: more than a page");
    mem = kalloc();
    80000e30:	00000097          	auipc	ra,0x0
    80000e34:	844080e7          	jalr	-1980(ra) # 80000674 <kalloc>
    memset(mem, 0, PGSIZE);
    80000e38:	00001637          	lui	a2,0x1
    80000e3c:	00000593          	li	a1,0
    mem = kalloc();
    80000e40:	00050493          	mv	s1,a0
    memset(mem, 0, PGSIZE);
    80000e44:	00000097          	auipc	ra,0x0
    80000e48:	888080e7          	jalr	-1912(ra) # 800006cc <memset>
    mappages(pagetable, 0, PGSIZE, (uint64_t)mem, PTE_W | PTE_R | PTE_X | PTE_U);
    80000e4c:	00048693          	mv	a3,s1
    80000e50:	00001637          	lui	a2,0x1
    80000e54:	00000593          	li	a1,0
    80000e58:	000a0513          	mv	a0,s4
    80000e5c:	01e00713          	li	a4,30
    80000e60:	00000097          	auipc	ra,0x0
    80000e64:	c74080e7          	jalr	-908(ra) # 80000ad4 <mappages>
    memmove(mem, src, sz);
}
    80000e68:	02013403          	ld	s0,32(sp)
    80000e6c:	02813083          	ld	ra,40(sp)
    80000e70:	00013a03          	ld	s4,0(sp)
    memmove(mem, src, sz);
    80000e74:	00090613          	mv	a2,s2
    80000e78:	00098593          	mv	a1,s3
}
    80000e7c:	01013903          	ld	s2,16(sp)
    80000e80:	00813983          	ld	s3,8(sp)
    memmove(mem, src, sz);
    80000e84:	00048513          	mv	a0,s1
}
    80000e88:	01813483          	ld	s1,24(sp)
    80000e8c:	03010113          	addi	sp,sp,48
    memmove(mem, src, sz);
    80000e90:	00000317          	auipc	t1,0x0
    80000e94:	8d030067          	jr	-1840(t1) # 80000760 <memmove>
        panic("uvmfirst: more than a page");
    80000e98:	00001517          	auipc	a0,0x1
    80000e9c:	28850513          	addi	a0,a0,648 # 80002120 <digits+0x110>
    80000ea0:	fffff097          	auipc	ra,0xfffff
    80000ea4:	484080e7          	jalr	1156(ra) # 80000324 <panic>
    80000ea8:	f89ff06f          	j	80000e30 <uvmfirst+0x34>

0000000080000eac <uvmalloc>:
uvmalloc(pagetable_t pagetable, uint64_t oldsz, uint64_t newsz, int xperm)
{
    char *mem;
    uint64_t a;

    if (newsz < oldsz)
    80000eac:	0eb66a63          	bltu	a2,a1,80000fa0 <uvmalloc+0xf4>
        return oldsz;

    oldsz = PGROUNDUP(oldsz);
    80000eb0:	000017b7          	lui	a5,0x1
{
    80000eb4:	fc010113          	addi	sp,sp,-64
    oldsz = PGROUNDUP(oldsz);
    80000eb8:	fff78793          	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
{
    80000ebc:	02813823          	sd	s0,48(sp)
    80000ec0:	03213023          	sd	s2,32(sp)
    80000ec4:	01313c23          	sd	s3,24(sp)
    80000ec8:	01413823          	sd	s4,16(sp)
    80000ecc:	01513423          	sd	s5,8(sp)
    80000ed0:	01613023          	sd	s6,0(sp)
    oldsz = PGROUNDUP(oldsz);
    80000ed4:	00f585b3          	add	a1,a1,a5
{
    80000ed8:	02113c23          	sd	ra,56(sp)
    80000edc:	02913423          	sd	s1,40(sp)
    80000ee0:	04010413          	addi	s0,sp,64
    oldsz = PGROUNDUP(oldsz);
    80000ee4:	fffff7b7          	lui	a5,0xfffff
    80000ee8:	00f5fb33          	and	s6,a1,a5
{
    80000eec:	00060a93          	mv	s5,a2
    80000ef0:	00050a13          	mv	s4,a0
    for (a = oldsz; a < newsz; a += PGSIZE)
    80000ef4:	000b0913          	mv	s2,s6
        {
            uvmdealloc(pagetable, a, oldsz);
            return 0;
        }
        memset(mem, 0, PGSIZE);
        if (mappages(pagetable, a, PGSIZE, (uint64_t)mem, PTE_R | PTE_U | xperm) != 0)
    80000ef8:	0126e993          	ori	s3,a3,18
    for (a = oldsz; a < newsz; a += PGSIZE)
    80000efc:	02cb6e63          	bltu	s6,a2,80000f38 <uvmalloc+0x8c>
    80000f00:	0a80006f          	j	80000fa8 <uvmalloc+0xfc>
        memset(mem, 0, PGSIZE);
    80000f04:	fffff097          	auipc	ra,0xfffff
    80000f08:	7c8080e7          	jalr	1992(ra) # 800006cc <memset>
        if (mappages(pagetable, a, PGSIZE, (uint64_t)mem, PTE_R | PTE_U | xperm) != 0)
    80000f0c:	00098713          	mv	a4,s3
    80000f10:	00048693          	mv	a3,s1
    80000f14:	00090593          	mv	a1,s2
    80000f18:	00001637          	lui	a2,0x1
    80000f1c:	000a0513          	mv	a0,s4
    80000f20:	00000097          	auipc	ra,0x0
    80000f24:	bb4080e7          	jalr	-1100(ra) # 80000ad4 <mappages>
    80000f28:	08051463          	bnez	a0,80000fb0 <uvmalloc+0x104>
    for (a = oldsz; a < newsz; a += PGSIZE)
    80000f2c:	000017b7          	lui	a5,0x1
    80000f30:	00f90933          	add	s2,s2,a5
    80000f34:	07597a63          	bgeu	s2,s5,80000fa8 <uvmalloc+0xfc>
        mem = kalloc();
    80000f38:	fffff097          	auipc	ra,0xfffff
    80000f3c:	73c080e7          	jalr	1852(ra) # 80000674 <kalloc>
        memset(mem, 0, PGSIZE);
    80000f40:	00001637          	lui	a2,0x1
    80000f44:	00000593          	li	a1,0
        mem = kalloc();
    80000f48:	00050493          	mv	s1,a0
        if (mem == 0)
    80000f4c:	fa051ce3          	bnez	a0,80000f04 <uvmalloc+0x58>
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64_t
uvmdealloc(pagetable_t pagetable, uint64_t oldsz, uint64_t newsz)
{
    if (newsz >= oldsz)
    80000f50:	032b7263          	bgeu	s6,s2,80000f74 <uvmalloc+0xc8>
        return oldsz;

    if (PGROUNDUP(newsz) < PGROUNDUP(oldsz))
    80000f54:	000017b7          	lui	a5,0x1
    80000f58:	fff78793          	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000f5c:	fffff737          	lui	a4,0xfffff
    80000f60:	00fb05b3          	add	a1,s6,a5
    80000f64:	00f907b3          	add	a5,s2,a5
    80000f68:	00e5f5b3          	and	a1,a1,a4
    80000f6c:	00e7f7b3          	and	a5,a5,a4
    80000f70:	06f5ee63          	bltu	a1,a5,80000fec <uvmalloc+0x140>
            return 0;
    80000f74:	00000513          	li	a0,0
}
    80000f78:	03813083          	ld	ra,56(sp)
    80000f7c:	03013403          	ld	s0,48(sp)
    80000f80:	02813483          	ld	s1,40(sp)
    80000f84:	02013903          	ld	s2,32(sp)
    80000f88:	01813983          	ld	s3,24(sp)
    80000f8c:	01013a03          	ld	s4,16(sp)
    80000f90:	00813a83          	ld	s5,8(sp)
    80000f94:	00013b03          	ld	s6,0(sp)
    80000f98:	04010113          	addi	sp,sp,64
    80000f9c:	00008067          	ret
    80000fa0:	00058513          	mv	a0,a1
    80000fa4:	00008067          	ret
            return 0;
    80000fa8:	000a8513          	mv	a0,s5
    80000fac:	fcdff06f          	j	80000f78 <uvmalloc+0xcc>
            kfree(mem);
    80000fb0:	00048513          	mv	a0,s1
    80000fb4:	fffff097          	auipc	ra,0xfffff
    80000fb8:	638080e7          	jalr	1592(ra) # 800005ec <kfree>
    if (newsz >= oldsz)
    80000fbc:	fb2b7ce3          	bgeu	s6,s2,80000f74 <uvmalloc+0xc8>
    if (PGROUNDUP(newsz) < PGROUNDUP(oldsz))
    80000fc0:	000017b7          	lui	a5,0x1
    80000fc4:	fff78793          	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000fc8:	fffff737          	lui	a4,0xfffff
    80000fcc:	00fb05b3          	add	a1,s6,a5
    80000fd0:	00f90933          	add	s2,s2,a5
    80000fd4:	00e5f5b3          	and	a1,a1,a4
    80000fd8:	00e97933          	and	s2,s2,a4
    80000fdc:	f925fce3          	bgeu	a1,s2,80000f74 <uvmalloc+0xc8>
    {
        int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80000fe0:	40b90633          	sub	a2,s2,a1
    80000fe4:	00c65613          	srli	a2,a2,0xc
    80000fe8:	00c0006f          	j	80000ff4 <uvmalloc+0x148>
    80000fec:	40b787b3          	sub	a5,a5,a1
    80000ff0:	00c7d613          	srli	a2,a5,0xc
        uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80000ff4:	00100693          	li	a3,1
    80000ff8:	0006061b          	sext.w	a2,a2
    80000ffc:	000a0513          	mv	a0,s4
    80001000:	00000097          	auipc	ra,0x0
    80001004:	c5c080e7          	jalr	-932(ra) # 80000c5c <uvmunmap>
    80001008:	f6dff06f          	j	80000f74 <uvmalloc+0xc8>

000000008000100c <uvmdealloc>:
{
    8000100c:	fe010113          	addi	sp,sp,-32
    80001010:	00813823          	sd	s0,16(sp)
    80001014:	00913423          	sd	s1,8(sp)
    80001018:	00113c23          	sd	ra,24(sp)
    8000101c:	02010413          	addi	s0,sp,32
    80001020:	00058493          	mv	s1,a1
    if (newsz >= oldsz)
    80001024:	02b67463          	bgeu	a2,a1,8000104c <uvmdealloc+0x40>
    if (PGROUNDUP(newsz) < PGROUNDUP(oldsz))
    80001028:	000017b7          	lui	a5,0x1
    8000102c:	fff78793          	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001030:	fffff6b7          	lui	a3,0xfffff
    80001034:	00f60733          	add	a4,a2,a5
    80001038:	00f587b3          	add	a5,a1,a5
    8000103c:	00d7f7b3          	and	a5,a5,a3
    80001040:	00d775b3          	and	a1,a4,a3
    80001044:	00060493          	mv	s1,a2
    80001048:	00f5ee63          	bltu	a1,a5,80001064 <uvmdealloc+0x58>
    }

    return newsz;
}
    8000104c:	01813083          	ld	ra,24(sp)
    80001050:	01013403          	ld	s0,16(sp)
    80001054:	00048513          	mv	a0,s1
    80001058:	00813483          	ld	s1,8(sp)
    8000105c:	02010113          	addi	sp,sp,32
    80001060:	00008067          	ret
        int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80001064:	40b787b3          	sub	a5,a5,a1
    80001068:	00c7d793          	srli	a5,a5,0xc
        uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    8000106c:	00100693          	li	a3,1
    80001070:	0007861b          	sext.w	a2,a5
    80001074:	00000097          	auipc	ra,0x0
    80001078:	be8080e7          	jalr	-1048(ra) # 80000c5c <uvmunmap>
}
    8000107c:	01813083          	ld	ra,24(sp)
    80001080:	01013403          	ld	s0,16(sp)
    80001084:	00048513          	mv	a0,s1
    80001088:	00813483          	ld	s1,8(sp)
    8000108c:	02010113          	addi	sp,sp,32
    80001090:	00008067          	ret

0000000080001094 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void freewalk(pagetable_t pagetable)
{
    80001094:	fc010113          	addi	sp,sp,-64
    80001098:	02813823          	sd	s0,48(sp)
    8000109c:	02913423          	sd	s1,40(sp)
    800010a0:	03213023          	sd	s2,32(sp)
    800010a4:	01313c23          	sd	s3,24(sp)
    800010a8:	01413823          	sd	s4,16(sp)
    800010ac:	01513423          	sd	s5,8(sp)
    800010b0:	02113c23          	sd	ra,56(sp)
    800010b4:	04010413          	addi	s0,sp,64
    800010b8:	00001937          	lui	s2,0x1
    800010bc:	00050a93          	mv	s5,a0
    800010c0:	00050493          	mv	s1,a0
    800010c4:	01250933          	add	s2,a0,s2
    // there are 2^9 = 512 PTEs in a page table.
    for (int i = 0; i < 512; i++)
    {
        pte_t pte = pagetable[i];
        if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0)
    800010c8:	00100993          	li	s3,1
            freewalk((pagetable_t)child);
            pagetable[i] = 0;
        }
        else if (pte & PTE_V)
        {
            panic("freewalk: leaf");
    800010cc:	00001a17          	auipc	s4,0x1
    800010d0:	074a0a13          	addi	s4,s4,116 # 80002140 <digits+0x130>
    800010d4:	00c0006f          	j	800010e0 <freewalk+0x4c>
    for (int i = 0; i < 512; i++)
    800010d8:	00848493          	addi	s1,s1,8
    800010dc:	03248663          	beq	s1,s2,80001108 <freewalk+0x74>
        pte_t pte = pagetable[i];
    800010e0:	0004b783          	ld	a5,0(s1)
        if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0)
    800010e4:	00f7f713          	andi	a4,a5,15
        else if (pte & PTE_V)
    800010e8:	0017f693          	andi	a3,a5,1
        if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0)
    800010ec:	05370463          	beq	a4,s3,80001134 <freewalk+0xa0>
        else if (pte & PTE_V)
    800010f0:	fe0684e3          	beqz	a3,800010d8 <freewalk+0x44>
            panic("freewalk: leaf");
    800010f4:	000a0513          	mv	a0,s4
    for (int i = 0; i < 512; i++)
    800010f8:	00848493          	addi	s1,s1,8
            panic("freewalk: leaf");
    800010fc:	fffff097          	auipc	ra,0xfffff
    80001100:	228080e7          	jalr	552(ra) # 80000324 <panic>
    for (int i = 0; i < 512; i++)
    80001104:	fd249ee3          	bne	s1,s2,800010e0 <freewalk+0x4c>
        }
    }
    kfree((void *)pagetable);
}
    80001108:	03013403          	ld	s0,48(sp)
    8000110c:	03813083          	ld	ra,56(sp)
    80001110:	02813483          	ld	s1,40(sp)
    80001114:	02013903          	ld	s2,32(sp)
    80001118:	01813983          	ld	s3,24(sp)
    8000111c:	01013a03          	ld	s4,16(sp)
    kfree((void *)pagetable);
    80001120:	000a8513          	mv	a0,s5
}
    80001124:	00813a83          	ld	s5,8(sp)
    80001128:	04010113          	addi	sp,sp,64
    kfree((void *)pagetable);
    8000112c:	fffff317          	auipc	t1,0xfffff
    80001130:	4c030067          	jr	1216(t1) # 800005ec <kfree>
            uint64_t child = PTE2PA(pte);
    80001134:	00a7d793          	srli	a5,a5,0xa
            freewalk((pagetable_t)child);
    80001138:	00c79513          	slli	a0,a5,0xc
    8000113c:	00000097          	auipc	ra,0x0
    80001140:	f58080e7          	jalr	-168(ra) # 80001094 <freewalk>
            pagetable[i] = 0;
    80001144:	0004b023          	sd	zero,0(s1)
    80001148:	f91ff06f          	j	800010d8 <freewalk+0x44>

000000008000114c <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void uvmfree(pagetable_t pagetable, uint64_t sz)
{
    8000114c:	fe010113          	addi	sp,sp,-32
    80001150:	00813823          	sd	s0,16(sp)
    80001154:	00913423          	sd	s1,8(sp)
    80001158:	00113c23          	sd	ra,24(sp)
    8000115c:	02010413          	addi	s0,sp,32
    80001160:	00050493          	mv	s1,a0
    if (sz > 0)
    80001164:	02059063          	bnez	a1,80001184 <uvmfree+0x38>
        uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
    freewalk(pagetable);
}
    80001168:	01013403          	ld	s0,16(sp)
    8000116c:	01813083          	ld	ra,24(sp)
    freewalk(pagetable);
    80001170:	00048513          	mv	a0,s1
}
    80001174:	00813483          	ld	s1,8(sp)
    80001178:	02010113          	addi	sp,sp,32
    freewalk(pagetable);
    8000117c:	00000317          	auipc	t1,0x0
    80001180:	f1830067          	jr	-232(t1) # 80001094 <freewalk>
        uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
    80001184:	000017b7          	lui	a5,0x1
    80001188:	fff78793          	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000118c:	00f585b3          	add	a1,a1,a5
    80001190:	00c5d613          	srli	a2,a1,0xc
    80001194:	00100693          	li	a3,1
    80001198:	00000593          	li	a1,0
    8000119c:	00000097          	auipc	ra,0x0
    800011a0:	ac0080e7          	jalr	-1344(ra) # 80000c5c <uvmunmap>
}
    800011a4:	01013403          	ld	s0,16(sp)
    800011a8:	01813083          	ld	ra,24(sp)
    freewalk(pagetable);
    800011ac:	00048513          	mv	a0,s1
}
    800011b0:	00813483          	ld	s1,8(sp)
    800011b4:	02010113          	addi	sp,sp,32
    freewalk(pagetable);
    800011b8:	00000317          	auipc	t1,0x0
    800011bc:	edc30067          	jr	-292(t1) # 80001094 <freewalk>

00000000800011c0 <uvmcopy>:
    pte_t *pte;
    uint64_t pa, i;
    uint32_t flags;
    char *mem;

    for (i = 0; i < sz; i += PGSIZE)
    800011c0:	14060e63          	beqz	a2,8000131c <uvmcopy+0x15c>
{
    800011c4:	fb010113          	addi	sp,sp,-80
    800011c8:	04813023          	sd	s0,64(sp)
    800011cc:	03313423          	sd	s3,40(sp)
    800011d0:	03413023          	sd	s4,32(sp)
    800011d4:	01513c23          	sd	s5,24(sp)
    800011d8:	01613823          	sd	s6,16(sp)
    800011dc:	01713423          	sd	s7,8(sp)
    800011e0:	01813023          	sd	s8,0(sp)
    800011e4:	04113423          	sd	ra,72(sp)
    800011e8:	02913c23          	sd	s1,56(sp)
    800011ec:	03213823          	sd	s2,48(sp)
    800011f0:	05010413          	addi	s0,sp,80
    800011f4:	00060a13          	mv	s4,a2
    800011f8:	00050b13          	mv	s6,a0
    800011fc:	00058a93          	mv	s5,a1
    80001200:	00000993          	li	s3,0
    80001204:	00001c17          	auipc	s8,0x1
    80001208:	f4cc0c13          	addi	s8,s8,-180 # 80002150 <digits+0x140>
    8000120c:	00001b97          	auipc	s7,0x1
    80001210:	f64b8b93          	addi	s7,s7,-156 # 80002170 <digits+0x160>
    80001214:	05c0006f          	j	80001270 <uvmcopy+0xb0>
    {
        if ((pte = walk(old, i, 0)) == 0)
            panic("uvmcopy: pte should exist");
        if ((*pte & PTE_V) == 0)
            panic("uvmcopy: page not present");
        pa = PTE2PA(*pte);
    80001218:	00a75913          	srli	s2,a4,0xa
    8000121c:	00c91913          	slli	s2,s2,0xc
        flags = PTE_FLAGS(*pte);
    80001220:	3ff77493          	andi	s1,a4,1023
        if ((mem = kalloc()) == 0)
    80001224:	fffff097          	auipc	ra,0xfffff
    80001228:	450080e7          	jalr	1104(ra) # 80000674 <kalloc>
            goto err;
        memmove(mem, (char *)pa, PGSIZE);
    8000122c:	00090593          	mv	a1,s2
    80001230:	00001637          	lui	a2,0x1
        if ((mem = kalloc()) == 0)
    80001234:	00050913          	mv	s2,a0
    80001238:	08050863          	beqz	a0,800012c8 <uvmcopy+0x108>
        memmove(mem, (char *)pa, PGSIZE);
    8000123c:	fffff097          	auipc	ra,0xfffff
    80001240:	524080e7          	jalr	1316(ra) # 80000760 <memmove>
        if (mappages(new, i, PGSIZE, (uint64_t)mem, flags) != 0)
    80001244:	00048713          	mv	a4,s1
    80001248:	00090693          	mv	a3,s2
    8000124c:	00098593          	mv	a1,s3
    80001250:	00001637          	lui	a2,0x1
    80001254:	000a8513          	mv	a0,s5
    80001258:	00000097          	auipc	ra,0x0
    8000125c:	87c080e7          	jalr	-1924(ra) # 80000ad4 <mappages>
    80001260:	04051e63          	bnez	a0,800012bc <uvmcopy+0xfc>
    for (i = 0; i < sz; i += PGSIZE)
    80001264:	000017b7          	lui	a5,0x1
    80001268:	00f989b3          	add	s3,s3,a5
    8000126c:	0b49f463          	bgeu	s3,s4,80001314 <uvmcopy+0x154>
        if ((pte = walk(old, i, 0)) == 0)
    80001270:	00098593          	mv	a1,s3
    80001274:	00000613          	li	a2,0
    80001278:	000b0513          	mv	a0,s6
    8000127c:	fffff097          	auipc	ra,0xfffff
    80001280:	6d4080e7          	jalr	1748(ra) # 80000950 <walk>
    80001284:	00050493          	mv	s1,a0
    80001288:	02050263          	beqz	a0,800012ac <uvmcopy+0xec>
        if ((*pte & PTE_V) == 0)
    8000128c:	0004b703          	ld	a4,0(s1)
    80001290:	00177793          	andi	a5,a4,1
    80001294:	f80792e3          	bnez	a5,80001218 <uvmcopy+0x58>
            panic("uvmcopy: page not present");
    80001298:	000b8513          	mv	a0,s7
    8000129c:	fffff097          	auipc	ra,0xfffff
    800012a0:	088080e7          	jalr	136(ra) # 80000324 <panic>
        pa = PTE2PA(*pte);
    800012a4:	0004b703          	ld	a4,0(s1)
    800012a8:	f71ff06f          	j	80001218 <uvmcopy+0x58>
            panic("uvmcopy: pte should exist");
    800012ac:	000c0513          	mv	a0,s8
    800012b0:	fffff097          	auipc	ra,0xfffff
    800012b4:	074080e7          	jalr	116(ra) # 80000324 <panic>
    800012b8:	fd5ff06f          	j	8000128c <uvmcopy+0xcc>
        {
            kfree(mem);
    800012bc:	00090513          	mv	a0,s2
    800012c0:	fffff097          	auipc	ra,0xfffff
    800012c4:	32c080e7          	jalr	812(ra) # 800005ec <kfree>
        }
    }
    return 0;

err:
    uvmunmap(new, 0, i / PGSIZE, 1);
    800012c8:	000a8513          	mv	a0,s5
    800012cc:	00100693          	li	a3,1
    800012d0:	00c9d613          	srli	a2,s3,0xc
    800012d4:	00000593          	li	a1,0
    800012d8:	00000097          	auipc	ra,0x0
    800012dc:	984080e7          	jalr	-1660(ra) # 80000c5c <uvmunmap>
    return -1;
    800012e0:	fff00513          	li	a0,-1
}
    800012e4:	04813083          	ld	ra,72(sp)
    800012e8:	04013403          	ld	s0,64(sp)
    800012ec:	03813483          	ld	s1,56(sp)
    800012f0:	03013903          	ld	s2,48(sp)
    800012f4:	02813983          	ld	s3,40(sp)
    800012f8:	02013a03          	ld	s4,32(sp)
    800012fc:	01813a83          	ld	s5,24(sp)
    80001300:	01013b03          	ld	s6,16(sp)
    80001304:	00813b83          	ld	s7,8(sp)
    80001308:	00013c03          	ld	s8,0(sp)
    8000130c:	05010113          	addi	sp,sp,80
    80001310:	00008067          	ret
    return 0;
    80001314:	00000513          	li	a0,0
    80001318:	fcdff06f          	j	800012e4 <uvmcopy+0x124>
    8000131c:	00000513          	li	a0,0
}
    80001320:	00008067          	ret

0000000080001324 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void uvmclear(pagetable_t pagetable, uint64_t va)
{
    80001324:	fe010113          	addi	sp,sp,-32
    80001328:	00813823          	sd	s0,16(sp)
    8000132c:	00913423          	sd	s1,8(sp)
    80001330:	00113c23          	sd	ra,24(sp)
    80001334:	02010413          	addi	s0,sp,32
    pte_t *pte;

    pte = walk(pagetable, va, 0);
    80001338:	00000613          	li	a2,0
    8000133c:	fffff097          	auipc	ra,0xfffff
    80001340:	614080e7          	jalr	1556(ra) # 80000950 <walk>
    80001344:	00050493          	mv	s1,a0
    if (pte == 0)
    80001348:	02050263          	beqz	a0,8000136c <uvmclear+0x48>
        panic("uvmclear");
    *pte &= ~PTE_U;
    8000134c:	0004b783          	ld	a5,0(s1)
}
    80001350:	01813083          	ld	ra,24(sp)
    80001354:	01013403          	ld	s0,16(sp)
    *pte &= ~PTE_U;
    80001358:	fef7f793          	andi	a5,a5,-17
    8000135c:	00f4b023          	sd	a5,0(s1)
}
    80001360:	00813483          	ld	s1,8(sp)
    80001364:	02010113          	addi	sp,sp,32
    80001368:	00008067          	ret
        panic("uvmclear");
    8000136c:	00001517          	auipc	a0,0x1
    80001370:	e2450513          	addi	a0,a0,-476 # 80002190 <digits+0x180>
    80001374:	fffff097          	auipc	ra,0xfffff
    80001378:	fb0080e7          	jalr	-80(ra) # 80000324 <panic>
    *pte &= ~PTE_U;
    8000137c:	0004b783          	ld	a5,0(s1)
}
    80001380:	01813083          	ld	ra,24(sp)
    80001384:	01013403          	ld	s0,16(sp)
    *pte &= ~PTE_U;
    80001388:	fef7f793          	andi	a5,a5,-17
    8000138c:	00f4b023          	sd	a5,0(s1)
}
    80001390:	00813483          	ld	s1,8(sp)
    80001394:	02010113          	addi	sp,sp,32
    80001398:	00008067          	ret

000000008000139c <copyout>:
// Return 0 on success, -1 on error.
int copyout(pagetable_t pagetable, uint64_t dstva, char *src, uint64_t len)
{
    uint64_t n, va0, pa0;

    while (len > 0)
    8000139c:	12068a63          	beqz	a3,800014d0 <copyout+0x134>
{
    800013a0:	fa010113          	addi	sp,sp,-96
    800013a4:	04813823          	sd	s0,80(sp)
    800013a8:	04913423          	sd	s1,72(sp)
    800013ac:	05213023          	sd	s2,64(sp)
    800013b0:	04113c23          	sd	ra,88(sp)
    800013b4:	03313c23          	sd	s3,56(sp)
    800013b8:	03413823          	sd	s4,48(sp)
    800013bc:	03513423          	sd	s5,40(sp)
    800013c0:	03613023          	sd	s6,32(sp)
    800013c4:	01713c23          	sd	s7,24(sp)
    800013c8:	01813823          	sd	s8,16(sp)
    800013cc:	01913423          	sd	s9,8(sp)
    800013d0:	06010413          	addi	s0,sp,96
    {
        va0 = PGROUNDDOWN(dstva);
    800013d4:	fffff937          	lui	s2,0xfffff
    if (va >= MAXVA)
    800013d8:	fff00793          	li	a5,-1
        va0 = PGROUNDDOWN(dstva);
    800013dc:	0125f933          	and	s2,a1,s2
    if (va >= MAXVA)
    800013e0:	01a7d793          	srli	a5,a5,0x1a
    800013e4:	00058493          	mv	s1,a1
    800013e8:	0327fe63          	bgeu	a5,s2,80001424 <copyout+0x88>
        pa0 = walkaddr(pagetable, va0);
        if (pa0 == 0)
            return -1;
    800013ec:	fff00513          	li	a0,-1
        len -= n;
        src += n;
        dstva = va0 + PGSIZE;
    }
    return 0;
}
    800013f0:	05813083          	ld	ra,88(sp)
    800013f4:	05013403          	ld	s0,80(sp)
    800013f8:	04813483          	ld	s1,72(sp)
    800013fc:	04013903          	ld	s2,64(sp)
    80001400:	03813983          	ld	s3,56(sp)
    80001404:	03013a03          	ld	s4,48(sp)
    80001408:	02813a83          	ld	s5,40(sp)
    8000140c:	02013b03          	ld	s6,32(sp)
    80001410:	01813b83          	ld	s7,24(sp)
    80001414:	01013c03          	ld	s8,16(sp)
    80001418:	00813c83          	ld	s9,8(sp)
    8000141c:	06010113          	addi	sp,sp,96
    80001420:	00008067          	ret
    80001424:	00050a93          	mv	s5,a0
    80001428:	00060a13          	mv	s4,a2
    pte = walk(pagetable, va, 0);
    8000142c:	00090593          	mv	a1,s2
    80001430:	00000613          	li	a2,0
    80001434:	000a8513          	mv	a0,s5
    80001438:	00068993          	mv	s3,a3
    if ((*pte & PTE_U) == 0)
    8000143c:	01100c13          	li	s8,17
    80001440:	00001bb7          	lui	s7,0x1
    if (va >= MAXVA)
    80001444:	00078b13          	mv	s6,a5
    pte = walk(pagetable, va, 0);
    80001448:	fffff097          	auipc	ra,0xfffff
    8000144c:	508080e7          	jalr	1288(ra) # 80000950 <walk>
    if (pte == 0)
    80001450:	f8050ee3          	beqz	a0,800013ec <copyout+0x50>
    if ((*pte & PTE_V) == 0)
    80001454:	00053783          	ld	a5,0(a0)
    if ((*pte & PTE_U) == 0)
    80001458:	01790cb3          	add	s9,s2,s7
        memmove((void *)(pa0 + (dstva - va0)), src, n);
    8000145c:	41248933          	sub	s2,s1,s2
    pa = PTE2PA(*pte);
    80001460:	00a7d713          	srli	a4,a5,0xa
    80001464:	00c71713          	slli	a4,a4,0xc
    if ((*pte & PTE_U) == 0)
    80001468:	0117f793          	andi	a5,a5,17
        n = PGSIZE - (dstva - va0);
    8000146c:	409c84b3          	sub	s1,s9,s1
        memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001470:	000a0593          	mv	a1,s4
    80001474:	00e90533          	add	a0,s2,a4
    if ((*pte & PTE_U) == 0)
    80001478:	f7879ae3          	bne	a5,s8,800013ec <copyout+0x50>
    8000147c:	000c8913          	mv	s2,s9
        if (pa0 == 0)
    80001480:	f60706e3          	beqz	a4,800013ec <copyout+0x50>
    80001484:	0099f463          	bgeu	s3,s1,8000148c <copyout+0xf0>
    80001488:	00098493          	mv	s1,s3
        memmove((void *)(pa0 + (dstva - va0)), src, n);
    8000148c:	0004861b          	sext.w	a2,s1
        len -= n;
    80001490:	409989b3          	sub	s3,s3,s1
        memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001494:	fffff097          	auipc	ra,0xfffff
    80001498:	2cc080e7          	jalr	716(ra) # 80000760 <memmove>
        src += n;
    8000149c:	009a0a33          	add	s4,s4,s1
    while (len > 0)
    800014a0:	02098463          	beqz	s3,800014c8 <copyout+0x12c>
    if (va >= MAXVA)
    800014a4:	f59b64e3          	bltu	s6,s9,800013ec <copyout+0x50>
    pte = walk(pagetable, va, 0);
    800014a8:	00090593          	mv	a1,s2
    800014ac:	00000613          	li	a2,0
    800014b0:	000a8513          	mv	a0,s5
    800014b4:	00090493          	mv	s1,s2
    800014b8:	fffff097          	auipc	ra,0xfffff
    800014bc:	498080e7          	jalr	1176(ra) # 80000950 <walk>
    if (pte == 0)
    800014c0:	f8051ae3          	bnez	a0,80001454 <copyout+0xb8>
    800014c4:	f29ff06f          	j	800013ec <copyout+0x50>
    return 0;
    800014c8:	00000513          	li	a0,0
    800014cc:	f25ff06f          	j	800013f0 <copyout+0x54>
    800014d0:	00000513          	li	a0,0
}
    800014d4:	00008067          	ret

00000000800014d8 <copyin>:
// Return 0 on success, -1 on error.
int copyin(pagetable_t pagetable, char *dst, uint64_t srcva, uint64_t len)
{
    uint64_t n, va0, pa0;

    while (len > 0)
    800014d8:	12068a63          	beqz	a3,8000160c <copyin+0x134>
{
    800014dc:	fa010113          	addi	sp,sp,-96
    800014e0:	04813823          	sd	s0,80(sp)
    800014e4:	04913423          	sd	s1,72(sp)
    800014e8:	05213023          	sd	s2,64(sp)
    800014ec:	04113c23          	sd	ra,88(sp)
    800014f0:	03313c23          	sd	s3,56(sp)
    800014f4:	03413823          	sd	s4,48(sp)
    800014f8:	03513423          	sd	s5,40(sp)
    800014fc:	03613023          	sd	s6,32(sp)
    80001500:	01713c23          	sd	s7,24(sp)
    80001504:	01813823          	sd	s8,16(sp)
    80001508:	01913423          	sd	s9,8(sp)
    8000150c:	06010413          	addi	s0,sp,96
    {
        va0 = PGROUNDDOWN(srcva);
    80001510:	fffff937          	lui	s2,0xfffff
    if (va >= MAXVA)
    80001514:	fff00793          	li	a5,-1
        va0 = PGROUNDDOWN(srcva);
    80001518:	01267933          	and	s2,a2,s2
    if (va >= MAXVA)
    8000151c:	01a7d793          	srli	a5,a5,0x1a
    80001520:	00060493          	mv	s1,a2
    80001524:	0327fe63          	bgeu	a5,s2,80001560 <copyin+0x88>
        pa0 = walkaddr(pagetable, va0);
        if (pa0 == 0)
            return -1;
    80001528:	fff00513          	li	a0,-1
        len -= n;
        dst += n;
        srcva = va0 + PGSIZE;
    }
    return 0;
}
    8000152c:	05813083          	ld	ra,88(sp)
    80001530:	05013403          	ld	s0,80(sp)
    80001534:	04813483          	ld	s1,72(sp)
    80001538:	04013903          	ld	s2,64(sp)
    8000153c:	03813983          	ld	s3,56(sp)
    80001540:	03013a03          	ld	s4,48(sp)
    80001544:	02813a83          	ld	s5,40(sp)
    80001548:	02013b03          	ld	s6,32(sp)
    8000154c:	01813b83          	ld	s7,24(sp)
    80001550:	01013c03          	ld	s8,16(sp)
    80001554:	00813c83          	ld	s9,8(sp)
    80001558:	06010113          	addi	sp,sp,96
    8000155c:	00008067          	ret
    80001560:	00050a93          	mv	s5,a0
    80001564:	00058a13          	mv	s4,a1
    pte = walk(pagetable, va, 0);
    80001568:	00000613          	li	a2,0
    8000156c:	00090593          	mv	a1,s2
    80001570:	000a8513          	mv	a0,s5
    80001574:	00068993          	mv	s3,a3
    if ((*pte & PTE_U) == 0)
    80001578:	01100c13          	li	s8,17
    8000157c:	00001bb7          	lui	s7,0x1
    if (va >= MAXVA)
    80001580:	00078b13          	mv	s6,a5
    pte = walk(pagetable, va, 0);
    80001584:	fffff097          	auipc	ra,0xfffff
    80001588:	3cc080e7          	jalr	972(ra) # 80000950 <walk>
    if (pte == 0)
    8000158c:	f8050ee3          	beqz	a0,80001528 <copyin+0x50>
    if ((*pte & PTE_V) == 0)
    80001590:	00053783          	ld	a5,0(a0)
    if ((*pte & PTE_U) == 0)
    80001594:	01790cb3          	add	s9,s2,s7
        memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001598:	41248933          	sub	s2,s1,s2
    pa = PTE2PA(*pte);
    8000159c:	00a7d713          	srli	a4,a5,0xa
    800015a0:	00c71713          	slli	a4,a4,0xc
    if ((*pte & PTE_U) == 0)
    800015a4:	0117f793          	andi	a5,a5,17
        n = PGSIZE - (srcva - va0);
    800015a8:	409c84b3          	sub	s1,s9,s1
        memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    800015ac:	000a0513          	mv	a0,s4
    800015b0:	00e905b3          	add	a1,s2,a4
    if ((*pte & PTE_U) == 0)
    800015b4:	f7879ae3          	bne	a5,s8,80001528 <copyin+0x50>
    800015b8:	000c8913          	mv	s2,s9
        if (pa0 == 0)
    800015bc:	f60706e3          	beqz	a4,80001528 <copyin+0x50>
    800015c0:	0099f463          	bgeu	s3,s1,800015c8 <copyin+0xf0>
    800015c4:	00098493          	mv	s1,s3
        memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    800015c8:	0004861b          	sext.w	a2,s1
        len -= n;
    800015cc:	409989b3          	sub	s3,s3,s1
        memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    800015d0:	fffff097          	auipc	ra,0xfffff
    800015d4:	190080e7          	jalr	400(ra) # 80000760 <memmove>
        dst += n;
    800015d8:	009a0a33          	add	s4,s4,s1
    while (len > 0)
    800015dc:	02098463          	beqz	s3,80001604 <copyin+0x12c>
    if (va >= MAXVA)
    800015e0:	f59b64e3          	bltu	s6,s9,80001528 <copyin+0x50>
    pte = walk(pagetable, va, 0);
    800015e4:	00090593          	mv	a1,s2
    800015e8:	00000613          	li	a2,0
    800015ec:	000a8513          	mv	a0,s5
    800015f0:	00090493          	mv	s1,s2
    800015f4:	fffff097          	auipc	ra,0xfffff
    800015f8:	35c080e7          	jalr	860(ra) # 80000950 <walk>
    if (pte == 0)
    800015fc:	f8051ae3          	bnez	a0,80001590 <copyin+0xb8>
    80001600:	f29ff06f          	j	80001528 <copyin+0x50>
    return 0;
    80001604:	00000513          	li	a0,0
    80001608:	f25ff06f          	j	8000152c <copyin+0x54>
    8000160c:	00000513          	li	a0,0
}
    80001610:	00008067          	ret

0000000080001614 <copyinstr>:
int copyinstr(pagetable_t pagetable, char *dst, uint64_t srcva, uint64_t max)
{
    uint64_t n, va0, pa0;
    int got_null = 0;

    while (got_null == 0 && max > 0)
    80001614:	14068463          	beqz	a3,8000175c <copyinstr+0x148>
{
    80001618:	fb010113          	addi	sp,sp,-80
    8000161c:	04813023          	sd	s0,64(sp)
    80001620:	03213823          	sd	s2,48(sp)
    80001624:	03313423          	sd	s3,40(sp)
    80001628:	01713423          	sd	s7,8(sp)
    8000162c:	04113423          	sd	ra,72(sp)
    80001630:	02913c23          	sd	s1,56(sp)
    80001634:	03413023          	sd	s4,32(sp)
    80001638:	01513c23          	sd	s5,24(sp)
    8000163c:	01613823          	sd	s6,16(sp)
    80001640:	01813023          	sd	s8,0(sp)
    80001644:	05010413          	addi	s0,sp,80
    {
        va0 = PGROUNDDOWN(srcva);
    80001648:	fffffbb7          	lui	s7,0xfffff
    if (va >= MAXVA)
    8000164c:	fff00993          	li	s3,-1
        va0 = PGROUNDDOWN(srcva);
    80001650:	01767bb3          	and	s7,a2,s7
    if (va >= MAXVA)
    80001654:	01a9d993          	srli	s3,s3,0x1a
    80001658:	00060913          	mv	s2,a2
    8000165c:	0379fc63          	bgeu	s3,s7,80001694 <copyinstr+0x80>
    {
        return 0;
    }
    else
    {
        return -1;
    80001660:	fff00513          	li	a0,-1
    }
}
    80001664:	04813083          	ld	ra,72(sp)
    80001668:	04013403          	ld	s0,64(sp)
    8000166c:	03813483          	ld	s1,56(sp)
    80001670:	03013903          	ld	s2,48(sp)
    80001674:	02813983          	ld	s3,40(sp)
    80001678:	02013a03          	ld	s4,32(sp)
    8000167c:	01813a83          	ld	s5,24(sp)
    80001680:	01013b03          	ld	s6,16(sp)
    80001684:	00813b83          	ld	s7,8(sp)
    80001688:	00013c03          	ld	s8,0(sp)
    8000168c:	05010113          	addi	sp,sp,80
    80001690:	00008067          	ret
    80001694:	00068b13          	mv	s6,a3
    80001698:	00050c13          	mv	s8,a0
    8000169c:	00058493          	mv	s1,a1
    if ((*pte & PTE_U) == 0)
    800016a0:	01100a93          	li	s5,17
    800016a4:	00001a37          	lui	s4,0x1
    pte = walk(pagetable, va, 0);
    800016a8:	00000613          	li	a2,0
    800016ac:	000b8593          	mv	a1,s7
    800016b0:	000c0513          	mv	a0,s8
    800016b4:	fffff097          	auipc	ra,0xfffff
    800016b8:	29c080e7          	jalr	668(ra) # 80000950 <walk>
    if (pte == 0)
    800016bc:	fa0502e3          	beqz	a0,80001660 <copyinstr+0x4c>
    if ((*pte & PTE_V) == 0)
    800016c0:	00053783          	ld	a5,0(a0)
    if ((*pte & PTE_U) == 0)
    800016c4:	0117f713          	andi	a4,a5,17
    800016c8:	f9571ce3          	bne	a4,s5,80001660 <copyinstr+0x4c>
    pa = PTE2PA(*pte);
    800016cc:	00a7d793          	srli	a5,a5,0xa
    800016d0:	00c79793          	slli	a5,a5,0xc
        if (pa0 == 0)
    800016d4:	f80786e3          	beqz	a5,80001660 <copyinstr+0x4c>
        n = PGSIZE - (srcva - va0);
    800016d8:	014b8533          	add	a0,s7,s4
    800016dc:	41250633          	sub	a2,a0,s2
    800016e0:	00cb7463          	bgeu	s6,a2,800016e8 <copyinstr+0xd4>
    800016e4:	000b0613          	mv	a2,s6
        char *p = (char *)(pa0 + (srcva - va0));
    800016e8:	41790933          	sub	s2,s2,s7
    800016ec:	00f90933          	add	s2,s2,a5
        while (n > 0)
    800016f0:	06060063          	beqz	a2,80001750 <copyinstr+0x13c>
    800016f4:	fffb0813          	addi	a6,s6,-1 # fff <_entry-0x7ffff001>
    800016f8:	00048593          	mv	a1,s1
    800016fc:	40990733          	sub	a4,s2,s1
    80001700:	00980833          	add	a6,a6,s1
    80001704:	00960633          	add	a2,a2,s1
    80001708:	0100006f          	j	80001718 <copyinstr+0x104>
                *dst = *p;
    8000170c:	00f58023          	sb	a5,0(a1)
            dst++;
    80001710:	00158593          	addi	a1,a1,1
        while (n > 0)
    80001714:	02c58063          	beq	a1,a2,80001734 <copyinstr+0x120>
            if (*p == '\0')
    80001718:	00e587b3          	add	a5,a1,a4
    8000171c:	0007c783          	lbu	a5,0(a5) # 1000 <_entry-0x7ffff000>
    80001720:	40b806b3          	sub	a3,a6,a1
    80001724:	fe0794e3          	bnez	a5,8000170c <copyinstr+0xf8>
                *dst = '\0';
    80001728:	00058023          	sb	zero,0(a1)
        return 0;
    8000172c:	00000513          	li	a0,0
    80001730:	f35ff06f          	j	80001664 <copyinstr+0x50>
    while (got_null == 0 && max > 0)
    80001734:	f20686e3          	beqz	a3,80001660 <copyinstr+0x4c>
    if (va >= MAXVA)
    80001738:	f2a9e4e3          	bltu	s3,a0,80001660 <copyinstr+0x4c>
    8000173c:	00050913          	mv	s2,a0
    80001740:	00068b13          	mv	s6,a3
    80001744:	00058493          	mv	s1,a1
    80001748:	00050b93          	mv	s7,a0
    8000174c:	f5dff06f          	j	800016a8 <copyinstr+0x94>
        while (n > 0)
    80001750:	000b0693          	mv	a3,s6
    80001754:	00048593          	mv	a1,s1
    80001758:	fe1ff06f          	j	80001738 <copyinstr+0x124>
        return -1;
    8000175c:	fff00513          	li	a0,-1
}
    80001760:	00008067          	ret

0000000080001764 <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void forkret(void)
{
    80001764:	ff010113          	addi	sp,sp,-16
    80001768:	00813423          	sd	s0,8(sp)
    8000176c:	01010413          	addi	s0,sp,16
    usertrapret();
}
    80001770:	00813403          	ld	s0,8(sp)
    80001774:	01010113          	addi	sp,sp,16
    usertrapret();
    80001778:	00000317          	auipc	t1,0x0
    8000177c:	60030067          	jr	1536(t1) # 80001d78 <usertrapret>

0000000080001780 <procinit>:
{
    80001780:	ff010113          	addi	sp,sp,-16
    80001784:	00813423          	sd	s0,8(sp)
    80001788:	01010413          	addi	s0,sp,16
}
    8000178c:	00813403          	ld	s0,8(sp)
        p->state = UNUSED;
    80001790:	00002797          	auipc	a5,0x2
    80001794:	a9078793          	addi	a5,a5,-1392 # 80003220 <proc>
    80001798:	0007a023          	sw	zero,0(a5)
    8000179c:	0a07a423          	sw	zero,168(a5)
    800017a0:	1407a823          	sw	zero,336(a5)
    800017a4:	1e07ac23          	sw	zero,504(a5)
}
    800017a8:	01010113          	addi	sp,sp,16
    800017ac:	00008067          	ret

00000000800017b0 <allocpid>:
{
    800017b0:	ff010113          	addi	sp,sp,-16
    800017b4:	00813423          	sd	s0,8(sp)
    800017b8:	01010413          	addi	s0,sp,16
    pid = nextpid;
    800017bc:	00001797          	auipc	a5,0x1
    800017c0:	a4478793          	addi	a5,a5,-1468 # 80002200 <nextpid>
    800017c4:	0007a503          	lw	a0,0(a5)
}
    800017c8:	00813403          	ld	s0,8(sp)
    nextpid = nextpid + 1;
    800017cc:	0015071b          	addiw	a4,a0,1
    800017d0:	00e7a023          	sw	a4,0(a5)
}
    800017d4:	01010113          	addi	sp,sp,16
    800017d8:	00008067          	ret

00000000800017dc <allocproc>:
{
    800017dc:	fe010113          	addi	sp,sp,-32
    800017e0:	00813823          	sd	s0,16(sp)
    800017e4:	00913423          	sd	s1,8(sp)
    800017e8:	00113c23          	sd	ra,24(sp)
    800017ec:	02010413          	addi	s0,sp,32
    for (p = proc; p < &proc[NPROC]; p++)
    800017f0:	00002497          	auipc	s1,0x2
    800017f4:	a3048493          	addi	s1,s1,-1488 # 80003220 <proc>
    800017f8:	00002717          	auipc	a4,0x2
    800017fc:	cc870713          	addi	a4,a4,-824 # 800034c0 <sc>
        if (p->state == UNUSED)
    80001800:	0004a783          	lw	a5,0(s1)
    80001804:	02078463          	beqz	a5,8000182c <allocproc+0x50>
    for (p = proc; p < &proc[NPROC]; p++)
    80001808:	0a848493          	addi	s1,s1,168
    8000180c:	fee49ae3          	bne	s1,a4,80001800 <allocproc+0x24>
}
    80001810:	01813083          	ld	ra,24(sp)
    80001814:	01013403          	ld	s0,16(sp)
        return 0;
    80001818:	00000493          	li	s1,0
}
    8000181c:	00048513          	mv	a0,s1
    80001820:	00813483          	ld	s1,8(sp)
    80001824:	02010113          	addi	sp,sp,32
    80001828:	00008067          	ret
    pid = nextpid;
    8000182c:	00001797          	auipc	a5,0x1
    80001830:	9d478793          	addi	a5,a5,-1580 # 80002200 <nextpid>
    80001834:	0007a703          	lw	a4,0(a5)
    p->state = USED;
    80001838:	00100693          	li	a3,1
    8000183c:	00d4a023          	sw	a3,0(s1)
    p->pid = allocpid();
    80001840:	00e4a223          	sw	a4,4(s1)
    nextpid = nextpid + 1;
    80001844:	0017069b          	addiw	a3,a4,1
    80001848:	00d7a023          	sw	a3,0(a5)
    if ((p->trapframe = (struct trapframe *)kalloc()) == 0)
    8000184c:	fffff097          	auipc	ra,0xfffff
    80001850:	e28080e7          	jalr	-472(ra) # 80000674 <kalloc>
    80001854:	02a4b023          	sd	a0,32(s1)
    80001858:	06050263          	beqz	a0,800018bc <allocproc+0xe0>
    pagetable = uvmcreate();
    8000185c:	fffff097          	auipc	ra,0xfffff
    80001860:	554080e7          	jalr	1364(ra) # 80000db0 <uvmcreate>
    if (pagetable == 0)
    80001864:	06050e63          	beqz	a0,800018e0 <allocproc+0x104>
    p->pagetable = proc_pagetable(p);
    80001868:	00a4bc23          	sd	a0,24(s1)
    memset(&p->context, 0, sizeof(p->context));
    8000186c:	07000613          	li	a2,112
    80001870:	00000593          	li	a1,0
    80001874:	02848513          	addi	a0,s1,40
    80001878:	fffff097          	auipc	ra,0xfffff
    8000187c:	e54080e7          	jalr	-428(ra) # 800006cc <memset>
    p->context.ra = (uint64_t)forkret;
    80001880:	00000797          	auipc	a5,0x0
    80001884:	ee478793          	addi	a5,a5,-284 # 80001764 <forkret>
    80001888:	02f4b423          	sd	a5,40(s1)
    p->kstack = (uint64_t)(kalloc() + PGSIZE);
    8000188c:	fffff097          	auipc	ra,0xfffff
    80001890:	de8080e7          	jalr	-536(ra) # 80000674 <kalloc>
}
    80001894:	01813083          	ld	ra,24(sp)
    80001898:	01013403          	ld	s0,16(sp)
    p->kstack = (uint64_t)(kalloc() + PGSIZE);
    8000189c:	000017b7          	lui	a5,0x1
    800018a0:	00f50533          	add	a0,a0,a5
    800018a4:	00a4b423          	sd	a0,8(s1)
    p->context.sp = p->kstack;
    800018a8:	02a4b823          	sd	a0,48(s1)
}
    800018ac:	00048513          	mv	a0,s1
    800018b0:	00813483          	ld	s1,8(sp)
    800018b4:	02010113          	addi	sp,sp,32
    800018b8:	00008067          	ret
    if (p->pagetable)
    800018bc:	0184b503          	ld	a0,24(s1)
    800018c0:	00050863          	beqz	a0,800018d0 <allocproc+0xf4>
    uvmfree(pagetable, sz);
    800018c4:	0104b583          	ld	a1,16(s1)
    800018c8:	00000097          	auipc	ra,0x0
    800018cc:	884080e7          	jalr	-1916(ra) # 8000114c <uvmfree>
    p->pagetable = 0;
    800018d0:	0004bc23          	sd	zero,24(s1)
    p->name[0] = 0;
    800018d4:	08048c23          	sb	zero,152(s1)
    p->state = UNUSED;
    800018d8:	0004b023          	sd	zero,0(s1)
    800018dc:	f35ff06f          	j	80001810 <allocproc+0x34>
    if (p->trapframe)
    800018e0:	0204b503          	ld	a0,32(s1)
    p->pagetable = proc_pagetable(p);
    800018e4:	0004bc23          	sd	zero,24(s1)
    if (p->trapframe)
    800018e8:	fe0504e3          	beqz	a0,800018d0 <allocproc+0xf4>
        kfree((void *)p->trapframe);
    800018ec:	fffff097          	auipc	ra,0xfffff
    800018f0:	d00080e7          	jalr	-768(ra) # 800005ec <kfree>
    if (p->pagetable)
    800018f4:	0184b503          	ld	a0,24(s1)
    p->trapframe = 0;
    800018f8:	0204b023          	sd	zero,32(s1)
    if (p->pagetable)
    800018fc:	fc0514e3          	bnez	a0,800018c4 <allocproc+0xe8>
    80001900:	fd1ff06f          	j	800018d0 <allocproc+0xf4>

0000000080001904 <proc_pagetable>:
{
    80001904:	ff010113          	addi	sp,sp,-16
    80001908:	00813423          	sd	s0,8(sp)
    8000190c:	01010413          	addi	s0,sp,16
}
    80001910:	00813403          	ld	s0,8(sp)
    80001914:	01010113          	addi	sp,sp,16
    pagetable = uvmcreate();
    80001918:	fffff317          	auipc	t1,0xfffff
    8000191c:	49830067          	jr	1176(t1) # 80000db0 <uvmcreate>

0000000080001920 <proc_freepagetable>:
{
    80001920:	ff010113          	addi	sp,sp,-16
    80001924:	00813423          	sd	s0,8(sp)
    80001928:	01010413          	addi	s0,sp,16
}
    8000192c:	00813403          	ld	s0,8(sp)
    80001930:	01010113          	addi	sp,sp,16
    uvmfree(pagetable, sz);
    80001934:	00000317          	auipc	t1,0x0
    80001938:	81830067          	jr	-2024(t1) # 8000114c <uvmfree>

000000008000193c <scheduler>:
{
    8000193c:	fc010113          	addi	sp,sp,-64
    80001940:	02813823          	sd	s0,48(sp)
    80001944:	03213023          	sd	s2,32(sp)
    80001948:	01313c23          	sd	s3,24(sp)
    8000194c:	01413823          	sd	s4,16(sp)
    80001950:	01513423          	sd	s5,8(sp)
    80001954:	01613023          	sd	s6,0(sp)
    80001958:	02113c23          	sd	ra,56(sp)
    8000195c:	02913423          	sd	s1,40(sp)
    80001960:	04010413          	addi	s0,sp,64
                w_satp(MAKE_SATP(p->pagetable));
    80001964:	fff00a13          	li	s4,-1
{
    80001968:	00001b17          	auipc	s6,0x1
    8000196c:	8b0b0b13          	addi	s6,s6,-1872 # 80002218 <cur_proc>
    80001970:	00002917          	auipc	s2,0x2
    80001974:	b5090913          	addi	s2,s2,-1200 # 800034c0 <sc>
            if (p->state == RUNNABLE)
    80001978:	00300993          	li	s3,3
                p->state = RUNNING;
    8000197c:	00400a93          	li	s5,4
                w_satp(MAKE_SATP(p->pagetable));
    80001980:	03fa1a13          	slli	s4,s4,0x3f
        for (p = proc; p < &proc[NPROC]; p++)
    80001984:	00002497          	auipc	s1,0x2
    80001988:	89c48493          	addi	s1,s1,-1892 # 80003220 <proc>
            if (p->state == RUNNABLE)
    8000198c:	0004a783          	lw	a5,0(s1)
    80001990:	01378a63          	beq	a5,s3,800019a4 <scheduler+0x68>
        for (p = proc; p < &proc[NPROC]; p++)
    80001994:	0a848493          	addi	s1,s1,168
    80001998:	ff2486e3          	beq	s1,s2,80001984 <scheduler+0x48>
            if (p->state == RUNNABLE)
    8000199c:	0004a783          	lw	a5,0(s1)
    800019a0:	ff379ae3          	bne	a5,s3,80001994 <scheduler+0x58>
                w_satp(MAKE_SATP(p->pagetable));
    800019a4:	0184b783          	ld	a5,24(s1)
                p->state = RUNNING;
    800019a8:	0154a023          	sw	s5,0(s1)
                myproc() = p;
    800019ac:	009b3023          	sd	s1,0(s6)
                w_satp(MAKE_SATP(p->pagetable));
    800019b0:	00c7d793          	srli	a5,a5,0xc
    800019b4:	0147e7b3          	or	a5,a5,s4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64_t x)
{
    asm volatile("csrw satp, %0" : : "r" (x));
    800019b8:	18079073          	csrw	satp,a5
}

static inline void 
w_mscratch(uint64_t x)
{
    asm volatile("csrw mscratch, %0" : : "r" (x));
    800019bc:	0204b783          	ld	a5,32(s1)
    800019c0:	34079073          	csrw	mscratch,a5
                swtch(&sc, &p->context);
    800019c4:	02848593          	addi	a1,s1,40
    800019c8:	00090513          	mv	a0,s2
    800019cc:	00000097          	auipc	ra,0x0
    800019d0:	134080e7          	jalr	308(ra) # 80001b00 <swtch>
    800019d4:	fc1ff06f          	j	80001994 <scheduler+0x58>

00000000800019d8 <sched>:
{
    800019d8:	ff010113          	addi	sp,sp,-16
    800019dc:	00813423          	sd	s0,8(sp)
    800019e0:	01010413          	addi	s0,sp,16
}
    800019e4:	00813403          	ld	s0,8(sp)
    swtch(&p->context, &sc);
    800019e8:	00001517          	auipc	a0,0x1
    800019ec:	83053503          	ld	a0,-2000(a0) # 80002218 <cur_proc>
    800019f0:	00002597          	auipc	a1,0x2
    800019f4:	ad058593          	addi	a1,a1,-1328 # 800034c0 <sc>
    800019f8:	02850513          	addi	a0,a0,40
}
    800019fc:	01010113          	addi	sp,sp,16
    swtch(&p->context, &sc);
    80001a00:	00000317          	auipc	t1,0x0
    80001a04:	10030067          	jr	256(t1) # 80001b00 <swtch>

0000000080001a08 <yield>:
{
    80001a08:	ff010113          	addi	sp,sp,-16
    80001a0c:	00813423          	sd	s0,8(sp)
    80001a10:	01010413          	addi	s0,sp,16
}
    80001a14:	00813403          	ld	s0,8(sp)
    struct proc *p = myproc();
    80001a18:	00001517          	auipc	a0,0x1
    80001a1c:	80053503          	ld	a0,-2048(a0) # 80002218 <cur_proc>
    p->state = RUNNABLE;
    80001a20:	00300793          	li	a5,3
    80001a24:	00f52023          	sw	a5,0(a0)
    swtch(&p->context, &sc);
    80001a28:	00002597          	auipc	a1,0x2
    80001a2c:	a9858593          	addi	a1,a1,-1384 # 800034c0 <sc>
    80001a30:	02850513          	addi	a0,a0,40
}
    80001a34:	01010113          	addi	sp,sp,16
    swtch(&p->context, &sc);
    80001a38:	00000317          	auipc	t1,0x0
    80001a3c:	0c830067          	jr	200(t1) # 80001b00 <swtch>

0000000080001a40 <userinit>:

extern char initcode[], initend[];
void userinit(void)
{
    80001a40:	fd010113          	addi	sp,sp,-48
    80001a44:	02813023          	sd	s0,32(sp)
    80001a48:	00913c23          	sd	s1,24(sp)
    80001a4c:	02113423          	sd	ra,40(sp)
    80001a50:	01213823          	sd	s2,16(sp)
    80001a54:	01313423          	sd	s3,8(sp)
    80001a58:	03010413          	addi	s0,sp,48
    struct proc *p = allocproc();
    80001a5c:	00000097          	auipc	ra,0x0
    80001a60:	d80080e7          	jalr	-640(ra) # 800017dc <allocproc>
    p->state = RUNNABLE;
    80001a64:	00300793          	li	a5,3
    80001a68:	00f52023          	sw	a5,0(a0)
    struct proc *p = allocproc();
    80001a6c:	00050493          	mv	s1,a0

    char *code = kalloc();
    80001a70:	fffff097          	auipc	ra,0xfffff
    80001a74:	c04080e7          	jalr	-1020(ra) # 80000674 <kalloc>
    if (code == 0) {
    80001a78:	06050663          	beqz	a0,80001ae4 <userinit+0xa4>
        printf("No enough memory");
        while (1);
    }

    memmove(code, initcode, initend - initcode);
    80001a7c:	00000597          	auipc	a1,0x0
    80001a80:	38058593          	addi	a1,a1,896 # 80001dfc <initcode>
    80001a84:	00000617          	auipc	a2,0x0
    80001a88:	38860613          	addi	a2,a2,904 # 80001e0c <initend>
    80001a8c:	40b6063b          	subw	a2,a2,a1
    80001a90:	00050913          	mv	s2,a0
    80001a94:	fffff097          	auipc	ra,0xfffff
    80001a98:	ccc080e7          	jalr	-820(ra) # 80000760 <memmove>
    mappages(p->pagetable, 0x7ffff0000ul, PGSIZE, (uint64_t)code, PTE_W|PTE_R|PTE_X|PTE_U);
    80001a9c:	0184b503          	ld	a0,24(s1)
    80001aa0:	7ffff9b7          	lui	s3,0x7ffff
    80001aa4:	00090693          	mv	a3,s2
    80001aa8:	00499593          	slli	a1,s3,0x4
    80001aac:	01e00713          	li	a4,30
    80001ab0:	00001637          	lui	a2,0x1
    80001ab4:	fffff097          	auipc	ra,0xfffff
    80001ab8:	020080e7          	jalr	32(ra) # 80000ad4 <mappages>
    p->trapframe->epc = 0x7ffff0000ul;
    80001abc:	0204b783          	ld	a5,32(s1)
    80001ac0:	02813083          	ld	ra,40(sp)
    80001ac4:	02013403          	ld	s0,32(sp)
    p->trapframe->epc = 0x7ffff0000ul;
    80001ac8:	00499993          	slli	s3,s3,0x4
    80001acc:	0137b423          	sd	s3,8(a5) # 1008 <_entry-0x7fffeff8>
    80001ad0:	01813483          	ld	s1,24(sp)
    80001ad4:	01013903          	ld	s2,16(sp)
    80001ad8:	00813983          	ld	s3,8(sp)
    80001adc:	03010113          	addi	sp,sp,48
    80001ae0:	00008067          	ret
        printf("No enough memory");
    80001ae4:	00000517          	auipc	a0,0x0
    80001ae8:	6bc50513          	addi	a0,a0,1724 # 800021a0 <digits+0x190>
    80001aec:	ffffe097          	auipc	ra,0xffffe
    80001af0:	644080e7          	jalr	1604(ra) # 80000130 <printf>
        while (1);
    80001af4:	0000006f          	j	80001af4 <userinit+0xb4>
	...

0000000080001b00 <swtch>:
.globl swtch
.align 4
swtch:
    sd ra, 0(a0)
    80001b00:	00153023          	sd	ra,0(a0)
    sd sp, 8(a0)
    80001b04:	00253423          	sd	sp,8(a0)
    sd s0, 16(a0)
    80001b08:	00853823          	sd	s0,16(a0)
    sd s1, 24(a0)
    80001b0c:	00953c23          	sd	s1,24(a0)
    sd s2, 32(a0)
    80001b10:	03253023          	sd	s2,32(a0)
    sd s3, 40(a0)
    80001b14:	03353423          	sd	s3,40(a0)
    sd s4, 48(a0)
    80001b18:	03453823          	sd	s4,48(a0)
    sd s5, 56(a0)
    80001b1c:	03553c23          	sd	s5,56(a0)
    sd s6, 64(a0)
    80001b20:	05653023          	sd	s6,64(a0)
    sd s7, 72(a0)
    80001b24:	05753423          	sd	s7,72(a0)
    sd s8, 80(a0)
    80001b28:	05853823          	sd	s8,80(a0)
    sd s9, 88(a0)
    80001b2c:	05953c23          	sd	s9,88(a0)
    sd s10, 96(a0)
    80001b30:	07a53023          	sd	s10,96(a0)
    sd s11, 104(a0)
    80001b34:	07b53423          	sd	s11,104(a0)

    ld ra, 0(a1)
    80001b38:	0005b083          	ld	ra,0(a1)
    ld sp, 8(a1)
    80001b3c:	0085b103          	ld	sp,8(a1)
    ld s0, 16(a1)
    80001b40:	0105b403          	ld	s0,16(a1)
    ld s1, 24(a1)
    80001b44:	0185b483          	ld	s1,24(a1)
    ld s2, 32(a1)
    80001b48:	0205b903          	ld	s2,32(a1)
    ld s3, 40(a1)
    80001b4c:	0285b983          	ld	s3,40(a1)
    ld s4, 48(a1)
    80001b50:	0305ba03          	ld	s4,48(a1)
    ld s5, 56(a1)
    80001b54:	0385ba83          	ld	s5,56(a1)
    ld s6, 64(a1)
    80001b58:	0405bb03          	ld	s6,64(a1)
    ld s7, 72(a1)
    80001b5c:	0485bb83          	ld	s7,72(a1)
    ld s8, 80(a1)
    80001b60:	0505bc03          	ld	s8,80(a1)
    ld s9, 88(a1)
    80001b64:	0585bc83          	ld	s9,88(a1)
    ld s10, 96(a1)
    80001b68:	0605bd03          	ld	s10,96(a1)
    ld s11, 104(a1)
    80001b6c:	0685bd83          	ld	s11,104(a1)
    
    ret
    80001b70:	00008067          	ret

0000000080001b74 <trapvec>:

.globl trapvec
.globl trap
trapvec:
    csrrw a0, mscratch, a0
    80001b74:	34051573          	csrrw	a0,mscratch,a0
    # Copied from xv6
    addi a0, a0, -24
    80001b78:	fe850513          	addi	a0,a0,-24
    sd ra, 40(a0)
    80001b7c:	02153423          	sd	ra,40(a0)
    sd sp, 48(a0)
    80001b80:	02253823          	sd	sp,48(a0)
    sd gp, 56(a0)
    80001b84:	02353c23          	sd	gp,56(a0)
    sd tp, 64(a0)
    80001b88:	04453023          	sd	tp,64(a0)
    sd t0, 72(a0)
    80001b8c:	04553423          	sd	t0,72(a0)
    sd t1, 80(a0)
    80001b90:	04653823          	sd	t1,80(a0)
    sd t2, 88(a0)
    80001b94:	04753c23          	sd	t2,88(a0)
    sd s0, 96(a0)
    80001b98:	06853023          	sd	s0,96(a0)
    sd s1, 104(a0)
    80001b9c:	06953423          	sd	s1,104(a0)
    sd a1, 120(a0)
    80001ba0:	06b53c23          	sd	a1,120(a0)
    sd a2, 128(a0)
    80001ba4:	08c53023          	sd	a2,128(a0)
    sd a3, 136(a0)
    80001ba8:	08d53423          	sd	a3,136(a0)
    sd a4, 144(a0)
    80001bac:	08e53823          	sd	a4,144(a0)
    sd a5, 152(a0)
    80001bb0:	08f53c23          	sd	a5,152(a0)
    sd a6, 160(a0)
    80001bb4:	0b053023          	sd	a6,160(a0)
    sd a7, 168(a0)
    80001bb8:	0b153423          	sd	a7,168(a0)
    sd s2, 176(a0)
    80001bbc:	0b253823          	sd	s2,176(a0)
    sd s3, 184(a0)
    80001bc0:	0b353c23          	sd	s3,184(a0)
    sd s4, 192(a0)
    80001bc4:	0d453023          	sd	s4,192(a0)
    sd s5, 200(a0)
    80001bc8:	0d553423          	sd	s5,200(a0)
    sd s6, 208(a0)
    80001bcc:	0d653823          	sd	s6,208(a0)
    sd s7, 216(a0)
    80001bd0:	0d753c23          	sd	s7,216(a0)
    sd s8, 224(a0)
    80001bd4:	0f853023          	sd	s8,224(a0)
    sd s9, 232(a0)
    80001bd8:	0f953423          	sd	s9,232(a0)
    sd s10, 240(a0)
    80001bdc:	0fa53823          	sd	s10,240(a0)
    sd s11, 248(a0)
    80001be0:	0fb53c23          	sd	s11,248(a0)
    sd t3, 256(a0)
    80001be4:	11c53023          	sd	t3,256(a0)
    sd t4, 264(a0)
    80001be8:	11d53423          	sd	t4,264(a0)
    sd t5, 272(a0)
    80001bec:	11e53823          	sd	t5,272(a0)
    sd t6, 280(a0)
    80001bf0:	11f53c23          	sd	t6,280(a0)

    csrr t0, mscratch
    80001bf4:	340022f3          	csrr	t0,mscratch
    sd t0, 112(a0)
    80001bf8:	06553823          	sd	t0,112(a0)

    addi a0, a0, 24
    80001bfc:	01850513          	addi	a0,a0,24

    # initialize kernel stack pointer, from p->trapframe->kernel_sp
    ld sp, 0(a0)
    80001c00:	00053103          	ld	sp,0(a0)
    csrr t0, mepc
    80001c04:	341022f3          	csrr	t0,mepc
    sd t0, 8(a0)
    80001c08:	00553423          	sd	t0,8(a0)

    csrw mscratch, a0 
    80001c0c:	34051073          	csrw	mscratch,a0

    sfence.vma zero, zero
    80001c10:	12000073          	sfence.vma

    call trap
    80001c14:	0c0000ef          	jal	ra,80001cd4 <trap>

0000000080001c18 <trapret>:

.globl trapret
trapret:
    csrrw a0, mscratch, a0
    80001c18:	34051573          	csrrw	a0,mscratch,a0
    sd sp, 0(a0)
    80001c1c:	00253023          	sd	sp,0(a0)
    ld t0, 8(a0)
    80001c20:	00853283          	ld	t0,8(a0)
    csrw mepc, t0
    80001c24:	34129073          	csrw	mepc,t0

    addi a0, a0, -24
    80001c28:	fe850513          	addi	a0,a0,-24
    # a0 is trapframe
    ld ra, 40(a0)
    80001c2c:	02853083          	ld	ra,40(a0)
    ld sp, 48(a0)
    80001c30:	03053103          	ld	sp,48(a0)
    ld gp, 56(a0)
    80001c34:	03853183          	ld	gp,56(a0)
    ld tp, 64(a0)
    80001c38:	04053203          	ld	tp,64(a0)
    ld t0, 72(a0)
    80001c3c:	04853283          	ld	t0,72(a0)
    ld t1, 80(a0)
    80001c40:	05053303          	ld	t1,80(a0)
    ld t2, 88(a0)
    80001c44:	05853383          	ld	t2,88(a0)
    ld s0, 96(a0)
    80001c48:	06053403          	ld	s0,96(a0)
    ld s1, 104(a0)
    80001c4c:	06853483          	ld	s1,104(a0)
    ld a1, 120(a0)
    80001c50:	07853583          	ld	a1,120(a0)
    ld a2, 128(a0)
    80001c54:	08053603          	ld	a2,128(a0)
    ld a3, 136(a0)
    80001c58:	08853683          	ld	a3,136(a0)
    ld a4, 144(a0)
    80001c5c:	09053703          	ld	a4,144(a0)
    ld a5, 152(a0)
    80001c60:	09853783          	ld	a5,152(a0)
    ld a6, 160(a0)
    80001c64:	0a053803          	ld	a6,160(a0)
    ld a7, 168(a0)
    80001c68:	0a853883          	ld	a7,168(a0)
    ld s2, 176(a0)
    80001c6c:	0b053903          	ld	s2,176(a0)
    ld s3, 184(a0)
    80001c70:	0b853983          	ld	s3,184(a0)
    ld s4, 192(a0)
    80001c74:	0c053a03          	ld	s4,192(a0)
    ld s5, 200(a0)
    80001c78:	0c853a83          	ld	s5,200(a0)
    ld s6, 208(a0)
    80001c7c:	0d053b03          	ld	s6,208(a0)
    ld s7, 216(a0)
    80001c80:	0d853b83          	ld	s7,216(a0)
    ld s8, 224(a0)
    80001c84:	0e053c03          	ld	s8,224(a0)
    ld s9, 232(a0)
    80001c88:	0e853c83          	ld	s9,232(a0)
    ld s10, 240(a0)
    80001c8c:	0f053d03          	ld	s10,240(a0)
    ld s11, 248(a0)
    80001c90:	0f853d83          	ld	s11,248(a0)
    ld t3, 256(a0)
    80001c94:	10053e03          	ld	t3,256(a0)
    ld t4, 264(a0)
    80001c98:	10853e83          	ld	t4,264(a0)
    ld t5, 272(a0)
    80001c9c:	11053f03          	ld	t5,272(a0)
    ld t6, 280(a0)
    80001ca0:	11853f83          	ld	t6,280(a0)
    # Write trapframe pointer to mscratch
    addi a0, a0, 24
    80001ca4:	01850513          	addi	a0,a0,24
    csrrw a0, mscratch, a0
    80001ca8:	34051573          	csrrw	a0,mscratch,a0

    80001cac:	30200073          	mret

0000000080001cb0 <trapinit>:
extern void panic(char *);

extern unsigned long syscall(unsigned long);
void
trapinit(void)
{
    80001cb0:	ff010113          	addi	sp,sp,-16
    80001cb4:	00813423          	sd	s0,8(sp)
    80001cb8:	01010413          	addi	s0,sp,16
    asm volatile("csrw mtvec, %0" : : "r" (x));
    80001cbc:	00000797          	auipc	a5,0x0
    80001cc0:	eb878793          	addi	a5,a5,-328 # 80001b74 <trapvec>
    80001cc4:	30579073          	csrw	mtvec,a5
    w_mtvec((uint64_t)trapvec);
}
    80001cc8:	00813403          	ld	s0,8(sp)
    80001ccc:	01010113          	addi	sp,sp,16
    80001cd0:	00008067          	ret

0000000080001cd4 <trap>:

void trap()
{
    80001cd4:	fe010113          	addi	sp,sp,-32
    80001cd8:	00813823          	sd	s0,16(sp)
    80001cdc:	00113c23          	sd	ra,24(sp)
    80001ce0:	00913423          	sd	s1,8(sp)
    80001ce4:	02010413          	addi	s0,sp,32
    asm volatile("csrr %0, mstatus" : "=r" (x) );
    80001ce8:	300027f3          	csrr	a5,mstatus
    if((r_mstatus() & MSTATUS_MPP_S) != 0)
    80001cec:	00b7d793          	srli	a5,a5,0xb
    80001cf0:	0017f793          	andi	a5,a5,1
    80001cf4:	02079663          	bnez	a5,80001d20 <trap+0x4c>

static inline uint64_t
r_mcause()
{
    uint64_t x;
    asm volatile("csrr %0, mcause" : "=r" (x) );
    80001cf8:	342027f3          	csrr	a5,mcause
        panic("usertrap: not from user mode");

    uint64_t mcause = r_mcause();
    if (mcause >> 31 == 0) {
    80001cfc:	01f7d713          	srli	a4,a5,0x1f
    80001d00:	00071663          	bnez	a4,80001d0c <trap+0x38>
        switch (mcause)
    80001d04:	00800713          	li	a4,8
    80001d08:	02e78663          	beq	a5,a4,80001d34 <trap+0x60>
        
        default:
            break;
        }
    }
}
    80001d0c:	01813083          	ld	ra,24(sp)
    80001d10:	01013403          	ld	s0,16(sp)
    80001d14:	00813483          	ld	s1,8(sp)
    80001d18:	02010113          	addi	sp,sp,32
    80001d1c:	00008067          	ret
        panic("usertrap: not from user mode");
    80001d20:	00000517          	auipc	a0,0x0
    80001d24:	49850513          	addi	a0,a0,1176 # 800021b8 <digits+0x1a8>
    80001d28:	ffffe097          	auipc	ra,0xffffe
    80001d2c:	5fc080e7          	jalr	1532(ra) # 80000324 <panic>
    80001d30:	fc9ff06f          	j	80001cf8 <trap+0x24>
            syscall(myproc()->trapframe->a7);
    80001d34:	00000497          	auipc	s1,0x0
    80001d38:	4e448493          	addi	s1,s1,1252 # 80002218 <cur_proc>
    80001d3c:	0004b783          	ld	a5,0(s1)
    80001d40:	0207b783          	ld	a5,32(a5)
    80001d44:	0907b503          	ld	a0,144(a5)
    80001d48:	00000097          	auipc	ra,0x0
    80001d4c:	0c8080e7          	jalr	200(ra) # 80001e10 <syscall>
            myproc()->trapframe->epc += 4;
    80001d50:	0004b783          	ld	a5,0(s1)
}
    80001d54:	01813083          	ld	ra,24(sp)
    80001d58:	01013403          	ld	s0,16(sp)
            myproc()->trapframe->epc += 4;
    80001d5c:	0207b703          	ld	a4,32(a5)
}
    80001d60:	00813483          	ld	s1,8(sp)
            myproc()->trapframe->epc += 4;
    80001d64:	00873783          	ld	a5,8(a4)
    80001d68:	00478793          	addi	a5,a5,4
    80001d6c:	00f73423          	sd	a5,8(a4)
}
    80001d70:	02010113          	addi	sp,sp,32
    80001d74:	00008067          	ret

0000000080001d78 <usertrapret>:

void
usertrapret(void)
{
    80001d78:	ff010113          	addi	sp,sp,-16
    80001d7c:	00813023          	sd	s0,0(sp)
    80001d80:	00113423          	sd	ra,8(sp)
    80001d84:	01010413          	addi	s0,sp,16
    struct proc *p = myproc();
    80001d88:	00000717          	auipc	a4,0x0
    80001d8c:	49073703          	ld	a4,1168(a4) # 80002218 <cur_proc>
    w_mepc(p->trapframe->epc);
    80001d90:	02073783          	ld	a5,32(a4)
    asm volatile("csrw mepc, %0" : : "r" (x));
    80001d94:	0087b783          	ld	a5,8(a5)
    80001d98:	34179073          	csrw	mepc,a5
    asm volatile("csrr %0, mstatus" : "=r" (x) );
    80001d9c:	300027f3          	csrr	a5,mstatus
    // trapret();

    unsigned long x = r_mstatus();
    x &= ~MSTATUS_MPP_U; // clear SPP to 0 for user mode
    x |= MSTATUS_MPIE; // enable interrupts in user mode
    80001da0:	0807e793          	ori	a5,a5,128
    asm volatile("csrw mstatus, %0" : : "r" (x));
    80001da4:	30079073          	csrw	mstatus,a5
    w_mstatus(x);
    w_satp((uint64_t)MAKE_SATP(p->pagetable));
    80001da8:	01873783          	ld	a5,24(a4)
    80001dac:	fff00713          	li	a4,-1
    80001db0:	03f71713          	slli	a4,a4,0x3f
    80001db4:	00c7d793          	srli	a5,a5,0xc
    80001db8:	00e7e7b3          	or	a5,a5,a4
    asm volatile("csrw satp, %0" : : "r" (x));
    80001dbc:	18079073          	csrw	satp,a5
    trapret();
    80001dc0:	00000097          	auipc	ra,0x0
    80001dc4:	e58080e7          	jalr	-424(ra) # 80001c18 <trapret>

    panic("");
    80001dc8:	00013403          	ld	s0,0(sp)
    80001dcc:	00813083          	ld	ra,8(sp)
    panic("");
    80001dd0:	00000517          	auipc	a0,0x0
    80001dd4:	3c850513          	addi	a0,a0,968 # 80002198 <digits+0x188>
    80001dd8:	01010113          	addi	sp,sp,16
    panic("");
    80001ddc:	ffffe317          	auipc	t1,0xffffe
    80001de0:	54830067          	jr	1352(t1) # 80000324 <panic>

0000000080001de4 <plicinit>:
void
plicinit(void)
{
    80001de4:	ff010113          	addi	sp,sp,-16
    80001de8:	00813423          	sd	s0,8(sp)
    80001dec:	01010413          	addi	s0,sp,16

    80001df0:	00813403          	ld	s0,8(sp)
    80001df4:	01010113          	addi	sp,sp,16
    80001df8:	00008067          	ret

0000000080001dfc <initcode>:

.global initcode
.global initend

initcode:
    li a7, SYS_INIT
    80001dfc:	000018b7          	lui	a7,0x1
    80001e00:	abc8889b          	addiw	a7,a7,-1348 # abc <_entry-0x7ffff544>
    ecall
    80001e04:	00000073          	ecall

0000000080001e08 <loop>:
loop:
    j loop
    80001e08:	0000006f          	j	80001e08 <loop>

0000000080001e0c <initend>:
    80001e0c:	04                	.byte	0x04
    80001e0d:	0000                	.2byte	0x0
	...

0000000080001e10 <syscall>:
#include "util.h"
#include "board.h"

uint64_t syscall(unsigned long x)
{
    switch (x)
    80001e10:	000017b7          	lui	a5,0x1
    80001e14:	abc78793          	addi	a5,a5,-1348 # abc <_entry-0x7ffff544>
    80001e18:	00f50663          	beq	a0,a5,80001e24 <syscall+0x14>
        return 0;
    
    default:
        break;
    }
    return -1;
    80001e1c:	fff00513          	li	a0,-1
    80001e20:	00008067          	ret
{
    80001e24:	ff010113          	addi	sp,sp,-16
    80001e28:	00813023          	sd	s0,0(sp)
    80001e2c:	00113423          	sd	ra,8(sp)
    80001e30:	01010413          	addi	s0,sp,16
        printf("Return from init! Test passed\n");
    80001e34:	00000517          	auipc	a0,0x0
    80001e38:	3a450513          	addi	a0,a0,932 # 800021d8 <digits+0x1c8>
    80001e3c:	ffffe097          	auipc	ra,0xffffe
    80001e40:	2f4080e7          	jalr	756(ra) # 80000130 <printf>
    80001e44:	00813083          	ld	ra,8(sp)
    80001e48:	00013403          	ld	s0,0(sp)
        return 0;
    80001e4c:	00000513          	li	a0,0
    80001e50:	01010113          	addi	sp,sp,16
    80001e54:	00008067          	ret
	...
