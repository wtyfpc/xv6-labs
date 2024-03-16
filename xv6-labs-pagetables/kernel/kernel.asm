
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	94013103          	ld	sp,-1728(sp) # 80008940 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	1a7050ef          	jal	ra,800059bc <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00022797          	auipc	a5,0x22
    80000034:	fd078793          	addi	a5,a5,-48 # 80022000 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	130080e7          	jalr	304(ra) # 80000178 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	94090913          	addi	s2,s2,-1728 # 80008990 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	362080e7          	jalr	866(ra) # 800063bc <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	402080e7          	jalr	1026(ra) # 80006470 <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f8e50513          	addi	a0,a0,-114 # 80008010 <etext+0x10>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	de8080e7          	jalr	-536(ra) # 80005e72 <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	addi	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	e84a                	sd	s2,16(sp)
    8000009c:	e44e                	sd	s3,8(sp)
    8000009e:	e052                	sd	s4,0(sp)
    800000a0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000a2:	6785                	lui	a5,0x1
    800000a4:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    800000a8:	94aa                	add	s1,s1,a0
    800000aa:	757d                	lui	a0,0xfffff
    800000ac:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ae:	94be                	add	s1,s1,a5
    800000b0:	0095ee63          	bltu	a1,s1,800000cc <freerange+0x3a>
    800000b4:	892e                	mv	s2,a1
    kfree(p);
    800000b6:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b8:	6985                	lui	s3,0x1
    kfree(p);
    800000ba:	01448533          	add	a0,s1,s4
    800000be:	00000097          	auipc	ra,0x0
    800000c2:	f5e080e7          	jalr	-162(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c6:	94ce                	add	s1,s1,s3
    800000c8:	fe9979e3          	bgeu	s2,s1,800000ba <freerange+0x28>
}
    800000cc:	70a2                	ld	ra,40(sp)
    800000ce:	7402                	ld	s0,32(sp)
    800000d0:	64e2                	ld	s1,24(sp)
    800000d2:	6942                	ld	s2,16(sp)
    800000d4:	69a2                	ld	s3,8(sp)
    800000d6:	6a02                	ld	s4,0(sp)
    800000d8:	6145                	addi	sp,sp,48
    800000da:	8082                	ret

00000000800000dc <kinit>:
{
    800000dc:	1141                	addi	sp,sp,-16
    800000de:	e406                	sd	ra,8(sp)
    800000e0:	e022                	sd	s0,0(sp)
    800000e2:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e4:	00008597          	auipc	a1,0x8
    800000e8:	f3458593          	addi	a1,a1,-204 # 80008018 <etext+0x18>
    800000ec:	00009517          	auipc	a0,0x9
    800000f0:	8a450513          	addi	a0,a0,-1884 # 80008990 <kmem>
    800000f4:	00006097          	auipc	ra,0x6
    800000f8:	238080e7          	jalr	568(ra) # 8000632c <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fc:	45c5                	li	a1,17
    800000fe:	05ee                	slli	a1,a1,0x1b
    80000100:	00022517          	auipc	a0,0x22
    80000104:	f0050513          	addi	a0,a0,-256 # 80022000 <end>
    80000108:	00000097          	auipc	ra,0x0
    8000010c:	f8a080e7          	jalr	-118(ra) # 80000092 <freerange>
}
    80000110:	60a2                	ld	ra,8(sp)
    80000112:	6402                	ld	s0,0(sp)
    80000114:	0141                	addi	sp,sp,16
    80000116:	8082                	ret

0000000080000118 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000118:	1101                	addi	sp,sp,-32
    8000011a:	ec06                	sd	ra,24(sp)
    8000011c:	e822                	sd	s0,16(sp)
    8000011e:	e426                	sd	s1,8(sp)
    80000120:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000122:	00009497          	auipc	s1,0x9
    80000126:	86e48493          	addi	s1,s1,-1938 # 80008990 <kmem>
    8000012a:	8526                	mv	a0,s1
    8000012c:	00006097          	auipc	ra,0x6
    80000130:	290080e7          	jalr	656(ra) # 800063bc <acquire>
  r = kmem.freelist;
    80000134:	6c84                	ld	s1,24(s1)
  if(r)
    80000136:	c885                	beqz	s1,80000166 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000138:	609c                	ld	a5,0(s1)
    8000013a:	00009517          	auipc	a0,0x9
    8000013e:	85650513          	addi	a0,a0,-1962 # 80008990 <kmem>
    80000142:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000144:	00006097          	auipc	ra,0x6
    80000148:	32c080e7          	jalr	812(ra) # 80006470 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014c:	6605                	lui	a2,0x1
    8000014e:	4595                	li	a1,5
    80000150:	8526                	mv	a0,s1
    80000152:	00000097          	auipc	ra,0x0
    80000156:	026080e7          	jalr	38(ra) # 80000178 <memset>
  return (void*)r;
}
    8000015a:	8526                	mv	a0,s1
    8000015c:	60e2                	ld	ra,24(sp)
    8000015e:	6442                	ld	s0,16(sp)
    80000160:	64a2                	ld	s1,8(sp)
    80000162:	6105                	addi	sp,sp,32
    80000164:	8082                	ret
  release(&kmem.lock);
    80000166:	00009517          	auipc	a0,0x9
    8000016a:	82a50513          	addi	a0,a0,-2006 # 80008990 <kmem>
    8000016e:	00006097          	auipc	ra,0x6
    80000172:	302080e7          	jalr	770(ra) # 80006470 <release>
  if(r)
    80000176:	b7d5                	j	8000015a <kalloc+0x42>

0000000080000178 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000178:	1141                	addi	sp,sp,-16
    8000017a:	e422                	sd	s0,8(sp)
    8000017c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    8000017e:	ce09                	beqz	a2,80000198 <memset+0x20>
    80000180:	87aa                	mv	a5,a0
    80000182:	fff6071b          	addiw	a4,a2,-1
    80000186:	1702                	slli	a4,a4,0x20
    80000188:	9301                	srli	a4,a4,0x20
    8000018a:	0705                	addi	a4,a4,1
    8000018c:	972a                	add	a4,a4,a0
    cdst[i] = c;
    8000018e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000192:	0785                	addi	a5,a5,1
    80000194:	fee79de3          	bne	a5,a4,8000018e <memset+0x16>
  }
  return dst;
}
    80000198:	6422                	ld	s0,8(sp)
    8000019a:	0141                	addi	sp,sp,16
    8000019c:	8082                	ret

000000008000019e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000019e:	1141                	addi	sp,sp,-16
    800001a0:	e422                	sd	s0,8(sp)
    800001a2:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001a4:	ca05                	beqz	a2,800001d4 <memcmp+0x36>
    800001a6:	fff6069b          	addiw	a3,a2,-1
    800001aa:	1682                	slli	a3,a3,0x20
    800001ac:	9281                	srli	a3,a3,0x20
    800001ae:	0685                	addi	a3,a3,1
    800001b0:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001b2:	00054783          	lbu	a5,0(a0)
    800001b6:	0005c703          	lbu	a4,0(a1)
    800001ba:	00e79863          	bne	a5,a4,800001ca <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001be:	0505                	addi	a0,a0,1
    800001c0:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001c2:	fed518e3          	bne	a0,a3,800001b2 <memcmp+0x14>
  }

  return 0;
    800001c6:	4501                	li	a0,0
    800001c8:	a019                	j	800001ce <memcmp+0x30>
      return *s1 - *s2;
    800001ca:	40e7853b          	subw	a0,a5,a4
}
    800001ce:	6422                	ld	s0,8(sp)
    800001d0:	0141                	addi	sp,sp,16
    800001d2:	8082                	ret
  return 0;
    800001d4:	4501                	li	a0,0
    800001d6:	bfe5                	j	800001ce <memcmp+0x30>

00000000800001d8 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001d8:	1141                	addi	sp,sp,-16
    800001da:	e422                	sd	s0,8(sp)
    800001dc:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001de:	ca0d                	beqz	a2,80000210 <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001e0:	00a5f963          	bgeu	a1,a0,800001f2 <memmove+0x1a>
    800001e4:	02061693          	slli	a3,a2,0x20
    800001e8:	9281                	srli	a3,a3,0x20
    800001ea:	00d58733          	add	a4,a1,a3
    800001ee:	02e56463          	bltu	a0,a4,80000216 <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001f2:	fff6079b          	addiw	a5,a2,-1
    800001f6:	1782                	slli	a5,a5,0x20
    800001f8:	9381                	srli	a5,a5,0x20
    800001fa:	0785                	addi	a5,a5,1
    800001fc:	97ae                	add	a5,a5,a1
    800001fe:	872a                	mv	a4,a0
      *d++ = *s++;
    80000200:	0585                	addi	a1,a1,1
    80000202:	0705                	addi	a4,a4,1
    80000204:	fff5c683          	lbu	a3,-1(a1)
    80000208:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    8000020c:	fef59ae3          	bne	a1,a5,80000200 <memmove+0x28>

  return dst;
}
    80000210:	6422                	ld	s0,8(sp)
    80000212:	0141                	addi	sp,sp,16
    80000214:	8082                	ret
    d += n;
    80000216:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000218:	fff6079b          	addiw	a5,a2,-1
    8000021c:	1782                	slli	a5,a5,0x20
    8000021e:	9381                	srli	a5,a5,0x20
    80000220:	fff7c793          	not	a5,a5
    80000224:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000226:	177d                	addi	a4,a4,-1
    80000228:	16fd                	addi	a3,a3,-1
    8000022a:	00074603          	lbu	a2,0(a4)
    8000022e:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000232:	fef71ae3          	bne	a4,a5,80000226 <memmove+0x4e>
    80000236:	bfe9                	j	80000210 <memmove+0x38>

0000000080000238 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000238:	1141                	addi	sp,sp,-16
    8000023a:	e406                	sd	ra,8(sp)
    8000023c:	e022                	sd	s0,0(sp)
    8000023e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000240:	00000097          	auipc	ra,0x0
    80000244:	f98080e7          	jalr	-104(ra) # 800001d8 <memmove>
}
    80000248:	60a2                	ld	ra,8(sp)
    8000024a:	6402                	ld	s0,0(sp)
    8000024c:	0141                	addi	sp,sp,16
    8000024e:	8082                	ret

0000000080000250 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000250:	1141                	addi	sp,sp,-16
    80000252:	e422                	sd	s0,8(sp)
    80000254:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000256:	ce11                	beqz	a2,80000272 <strncmp+0x22>
    80000258:	00054783          	lbu	a5,0(a0)
    8000025c:	cf89                	beqz	a5,80000276 <strncmp+0x26>
    8000025e:	0005c703          	lbu	a4,0(a1)
    80000262:	00f71a63          	bne	a4,a5,80000276 <strncmp+0x26>
    n--, p++, q++;
    80000266:	367d                	addiw	a2,a2,-1
    80000268:	0505                	addi	a0,a0,1
    8000026a:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    8000026c:	f675                	bnez	a2,80000258 <strncmp+0x8>
  if(n == 0)
    return 0;
    8000026e:	4501                	li	a0,0
    80000270:	a809                	j	80000282 <strncmp+0x32>
    80000272:	4501                	li	a0,0
    80000274:	a039                	j	80000282 <strncmp+0x32>
  if(n == 0)
    80000276:	ca09                	beqz	a2,80000288 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000278:	00054503          	lbu	a0,0(a0)
    8000027c:	0005c783          	lbu	a5,0(a1)
    80000280:	9d1d                	subw	a0,a0,a5
}
    80000282:	6422                	ld	s0,8(sp)
    80000284:	0141                	addi	sp,sp,16
    80000286:	8082                	ret
    return 0;
    80000288:	4501                	li	a0,0
    8000028a:	bfe5                	j	80000282 <strncmp+0x32>

000000008000028c <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    8000028c:	1141                	addi	sp,sp,-16
    8000028e:	e422                	sd	s0,8(sp)
    80000290:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000292:	872a                	mv	a4,a0
    80000294:	8832                	mv	a6,a2
    80000296:	367d                	addiw	a2,a2,-1
    80000298:	01005963          	blez	a6,800002aa <strncpy+0x1e>
    8000029c:	0705                	addi	a4,a4,1
    8000029e:	0005c783          	lbu	a5,0(a1)
    800002a2:	fef70fa3          	sb	a5,-1(a4)
    800002a6:	0585                	addi	a1,a1,1
    800002a8:	f7f5                	bnez	a5,80000294 <strncpy+0x8>
    ;
  while(n-- > 0)
    800002aa:	00c05d63          	blez	a2,800002c4 <strncpy+0x38>
    800002ae:	86ba                	mv	a3,a4
    *s++ = 0;
    800002b0:	0685                	addi	a3,a3,1
    800002b2:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800002b6:	fff6c793          	not	a5,a3
    800002ba:	9fb9                	addw	a5,a5,a4
    800002bc:	010787bb          	addw	a5,a5,a6
    800002c0:	fef048e3          	bgtz	a5,800002b0 <strncpy+0x24>
  return os;
}
    800002c4:	6422                	ld	s0,8(sp)
    800002c6:	0141                	addi	sp,sp,16
    800002c8:	8082                	ret

00000000800002ca <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002ca:	1141                	addi	sp,sp,-16
    800002cc:	e422                	sd	s0,8(sp)
    800002ce:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002d0:	02c05363          	blez	a2,800002f6 <safestrcpy+0x2c>
    800002d4:	fff6069b          	addiw	a3,a2,-1
    800002d8:	1682                	slli	a3,a3,0x20
    800002da:	9281                	srli	a3,a3,0x20
    800002dc:	96ae                	add	a3,a3,a1
    800002de:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002e0:	00d58963          	beq	a1,a3,800002f2 <safestrcpy+0x28>
    800002e4:	0585                	addi	a1,a1,1
    800002e6:	0785                	addi	a5,a5,1
    800002e8:	fff5c703          	lbu	a4,-1(a1)
    800002ec:	fee78fa3          	sb	a4,-1(a5)
    800002f0:	fb65                	bnez	a4,800002e0 <safestrcpy+0x16>
    ;
  *s = 0;
    800002f2:	00078023          	sb	zero,0(a5)
  return os;
}
    800002f6:	6422                	ld	s0,8(sp)
    800002f8:	0141                	addi	sp,sp,16
    800002fa:	8082                	ret

00000000800002fc <strlen>:

int
strlen(const char *s)
{
    800002fc:	1141                	addi	sp,sp,-16
    800002fe:	e422                	sd	s0,8(sp)
    80000300:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000302:	00054783          	lbu	a5,0(a0)
    80000306:	cf91                	beqz	a5,80000322 <strlen+0x26>
    80000308:	0505                	addi	a0,a0,1
    8000030a:	87aa                	mv	a5,a0
    8000030c:	4685                	li	a3,1
    8000030e:	9e89                	subw	a3,a3,a0
    80000310:	00f6853b          	addw	a0,a3,a5
    80000314:	0785                	addi	a5,a5,1
    80000316:	fff7c703          	lbu	a4,-1(a5)
    8000031a:	fb7d                	bnez	a4,80000310 <strlen+0x14>
    ;
  return n;
}
    8000031c:	6422                	ld	s0,8(sp)
    8000031e:	0141                	addi	sp,sp,16
    80000320:	8082                	ret
  for(n = 0; s[n]; n++)
    80000322:	4501                	li	a0,0
    80000324:	bfe5                	j	8000031c <strlen+0x20>

0000000080000326 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000326:	1141                	addi	sp,sp,-16
    80000328:	e406                	sd	ra,8(sp)
    8000032a:	e022                	sd	s0,0(sp)
    8000032c:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    8000032e:	00001097          	auipc	ra,0x1
    80000332:	be6080e7          	jalr	-1050(ra) # 80000f14 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000336:	00008717          	auipc	a4,0x8
    8000033a:	62a70713          	addi	a4,a4,1578 # 80008960 <started>
  if(cpuid() == 0){
    8000033e:	c139                	beqz	a0,80000384 <main+0x5e>
    while(started == 0)
    80000340:	431c                	lw	a5,0(a4)
    80000342:	2781                	sext.w	a5,a5
    80000344:	dff5                	beqz	a5,80000340 <main+0x1a>
      ;
    __sync_synchronize();
    80000346:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    8000034a:	00001097          	auipc	ra,0x1
    8000034e:	bca080e7          	jalr	-1078(ra) # 80000f14 <cpuid>
    80000352:	85aa                	mv	a1,a0
    80000354:	00008517          	auipc	a0,0x8
    80000358:	ce450513          	addi	a0,a0,-796 # 80008038 <etext+0x38>
    8000035c:	00006097          	auipc	ra,0x6
    80000360:	b60080e7          	jalr	-1184(ra) # 80005ebc <printf>
    kvminithart();    // turn on paging
    80000364:	00000097          	auipc	ra,0x0
    80000368:	0d8080e7          	jalr	216(ra) # 8000043c <kvminithart>
    trapinithart();   // install kernel trap vector
    8000036c:	00002097          	auipc	ra,0x2
    80000370:	934080e7          	jalr	-1740(ra) # 80001ca0 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000374:	00005097          	auipc	ra,0x5
    80000378:	f9c080e7          	jalr	-100(ra) # 80005310 <plicinithart>
  }

  scheduler();        
    8000037c:	00001097          	auipc	ra,0x1
    80000380:	17e080e7          	jalr	382(ra) # 800014fa <scheduler>
    consoleinit();
    80000384:	00006097          	auipc	ra,0x6
    80000388:	a00080e7          	jalr	-1536(ra) # 80005d84 <consoleinit>
    printfinit();
    8000038c:	00006097          	auipc	ra,0x6
    80000390:	d16080e7          	jalr	-746(ra) # 800060a2 <printfinit>
    printf("\n");
    80000394:	00008517          	auipc	a0,0x8
    80000398:	cb450513          	addi	a0,a0,-844 # 80008048 <etext+0x48>
    8000039c:	00006097          	auipc	ra,0x6
    800003a0:	b20080e7          	jalr	-1248(ra) # 80005ebc <printf>
    printf("xv6 kernel is booting\n");
    800003a4:	00008517          	auipc	a0,0x8
    800003a8:	c7c50513          	addi	a0,a0,-900 # 80008020 <etext+0x20>
    800003ac:	00006097          	auipc	ra,0x6
    800003b0:	b10080e7          	jalr	-1264(ra) # 80005ebc <printf>
    printf("\n");
    800003b4:	00008517          	auipc	a0,0x8
    800003b8:	c9450513          	addi	a0,a0,-876 # 80008048 <etext+0x48>
    800003bc:	00006097          	auipc	ra,0x6
    800003c0:	b00080e7          	jalr	-1280(ra) # 80005ebc <printf>
    kinit();         // physical page allocator
    800003c4:	00000097          	auipc	ra,0x0
    800003c8:	d18080e7          	jalr	-744(ra) # 800000dc <kinit>
    kvminit();       // create kernel page table
    800003cc:	00000097          	auipc	ra,0x0
    800003d0:	326080e7          	jalr	806(ra) # 800006f2 <kvminit>
    kvminithart();   // turn on paging
    800003d4:	00000097          	auipc	ra,0x0
    800003d8:	068080e7          	jalr	104(ra) # 8000043c <kvminithart>
    procinit();      // process table
    800003dc:	00001097          	auipc	ra,0x1
    800003e0:	a86080e7          	jalr	-1402(ra) # 80000e62 <procinit>
    trapinit();      // trap vectors
    800003e4:	00002097          	auipc	ra,0x2
    800003e8:	894080e7          	jalr	-1900(ra) # 80001c78 <trapinit>
    trapinithart();  // install kernel trap vector
    800003ec:	00002097          	auipc	ra,0x2
    800003f0:	8b4080e7          	jalr	-1868(ra) # 80001ca0 <trapinithart>
    plicinit();      // set up interrupt controller
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	f06080e7          	jalr	-250(ra) # 800052fa <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003fc:	00005097          	auipc	ra,0x5
    80000400:	f14080e7          	jalr	-236(ra) # 80005310 <plicinithart>
    binit();         // buffer cache
    80000404:	00002097          	auipc	ra,0x2
    80000408:	0c0080e7          	jalr	192(ra) # 800024c4 <binit>
    iinit();         // inode table
    8000040c:	00002097          	auipc	ra,0x2
    80000410:	764080e7          	jalr	1892(ra) # 80002b70 <iinit>
    fileinit();      // file table
    80000414:	00003097          	auipc	ra,0x3
    80000418:	702080e7          	jalr	1794(ra) # 80003b16 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000041c:	00005097          	auipc	ra,0x5
    80000420:	ffc080e7          	jalr	-4(ra) # 80005418 <virtio_disk_init>
    userinit();      // first user process
    80000424:	00001097          	auipc	ra,0x1
    80000428:	ebc080e7          	jalr	-324(ra) # 800012e0 <userinit>
    __sync_synchronize();
    8000042c:	0ff0000f          	fence
    started = 1;
    80000430:	4785                	li	a5,1
    80000432:	00008717          	auipc	a4,0x8
    80000436:	52f72723          	sw	a5,1326(a4) # 80008960 <started>
    8000043a:	b789                	j	8000037c <main+0x56>

000000008000043c <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000043c:	1141                	addi	sp,sp,-16
    8000043e:	e422                	sd	s0,8(sp)
    80000440:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000442:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000446:	00008797          	auipc	a5,0x8
    8000044a:	5227b783          	ld	a5,1314(a5) # 80008968 <kernel_pagetable>
    8000044e:	83b1                	srli	a5,a5,0xc
    80000450:	577d                	li	a4,-1
    80000452:	177e                	slli	a4,a4,0x3f
    80000454:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000456:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    8000045a:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    8000045e:	6422                	ld	s0,8(sp)
    80000460:	0141                	addi	sp,sp,16
    80000462:	8082                	ret

0000000080000464 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000464:	7139                	addi	sp,sp,-64
    80000466:	fc06                	sd	ra,56(sp)
    80000468:	f822                	sd	s0,48(sp)
    8000046a:	f426                	sd	s1,40(sp)
    8000046c:	f04a                	sd	s2,32(sp)
    8000046e:	ec4e                	sd	s3,24(sp)
    80000470:	e852                	sd	s4,16(sp)
    80000472:	e456                	sd	s5,8(sp)
    80000474:	e05a                	sd	s6,0(sp)
    80000476:	0080                	addi	s0,sp,64
    80000478:	84aa                	mv	s1,a0
    8000047a:	89ae                	mv	s3,a1
    8000047c:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    8000047e:	57fd                	li	a5,-1
    80000480:	83e9                	srli	a5,a5,0x1a
    80000482:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000484:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000486:	04b7f263          	bgeu	a5,a1,800004ca <walk+0x66>
    panic("walk");
    8000048a:	00008517          	auipc	a0,0x8
    8000048e:	bc650513          	addi	a0,a0,-1082 # 80008050 <etext+0x50>
    80000492:	00006097          	auipc	ra,0x6
    80000496:	9e0080e7          	jalr	-1568(ra) # 80005e72 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    8000049a:	060a8663          	beqz	s5,80000506 <walk+0xa2>
    8000049e:	00000097          	auipc	ra,0x0
    800004a2:	c7a080e7          	jalr	-902(ra) # 80000118 <kalloc>
    800004a6:	84aa                	mv	s1,a0
    800004a8:	c529                	beqz	a0,800004f2 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004aa:	6605                	lui	a2,0x1
    800004ac:	4581                	li	a1,0
    800004ae:	00000097          	auipc	ra,0x0
    800004b2:	cca080e7          	jalr	-822(ra) # 80000178 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004b6:	00c4d793          	srli	a5,s1,0xc
    800004ba:	07aa                	slli	a5,a5,0xa
    800004bc:	0017e793          	ori	a5,a5,1
    800004c0:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004c4:	3a5d                	addiw	s4,s4,-9
    800004c6:	036a0063          	beq	s4,s6,800004e6 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004ca:	0149d933          	srl	s2,s3,s4
    800004ce:	1ff97913          	andi	s2,s2,511
    800004d2:	090e                	slli	s2,s2,0x3
    800004d4:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004d6:	00093483          	ld	s1,0(s2)
    800004da:	0014f793          	andi	a5,s1,1
    800004de:	dfd5                	beqz	a5,8000049a <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004e0:	80a9                	srli	s1,s1,0xa
    800004e2:	04b2                	slli	s1,s1,0xc
    800004e4:	b7c5                	j	800004c4 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004e6:	00c9d513          	srli	a0,s3,0xc
    800004ea:	1ff57513          	andi	a0,a0,511
    800004ee:	050e                	slli	a0,a0,0x3
    800004f0:	9526                	add	a0,a0,s1
}
    800004f2:	70e2                	ld	ra,56(sp)
    800004f4:	7442                	ld	s0,48(sp)
    800004f6:	74a2                	ld	s1,40(sp)
    800004f8:	7902                	ld	s2,32(sp)
    800004fa:	69e2                	ld	s3,24(sp)
    800004fc:	6a42                	ld	s4,16(sp)
    800004fe:	6aa2                	ld	s5,8(sp)
    80000500:	6b02                	ld	s6,0(sp)
    80000502:	6121                	addi	sp,sp,64
    80000504:	8082                	ret
        return 0;
    80000506:	4501                	li	a0,0
    80000508:	b7ed                	j	800004f2 <walk+0x8e>

000000008000050a <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000050a:	57fd                	li	a5,-1
    8000050c:	83e9                	srli	a5,a5,0x1a
    8000050e:	00b7f463          	bgeu	a5,a1,80000516 <walkaddr+0xc>
    return 0;
    80000512:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000514:	8082                	ret
{
    80000516:	1141                	addi	sp,sp,-16
    80000518:	e406                	sd	ra,8(sp)
    8000051a:	e022                	sd	s0,0(sp)
    8000051c:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000051e:	4601                	li	a2,0
    80000520:	00000097          	auipc	ra,0x0
    80000524:	f44080e7          	jalr	-188(ra) # 80000464 <walk>
  if(pte == 0)
    80000528:	c105                	beqz	a0,80000548 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    8000052a:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000052c:	0117f693          	andi	a3,a5,17
    80000530:	4745                	li	a4,17
    return 0;
    80000532:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000534:	00e68663          	beq	a3,a4,80000540 <walkaddr+0x36>
}
    80000538:	60a2                	ld	ra,8(sp)
    8000053a:	6402                	ld	s0,0(sp)
    8000053c:	0141                	addi	sp,sp,16
    8000053e:	8082                	ret
  pa = PTE2PA(*pte);
    80000540:	00a7d513          	srli	a0,a5,0xa
    80000544:	0532                	slli	a0,a0,0xc
  return pa;
    80000546:	bfcd                	j	80000538 <walkaddr+0x2e>
    return 0;
    80000548:	4501                	li	a0,0
    8000054a:	b7fd                	j	80000538 <walkaddr+0x2e>

000000008000054c <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000054c:	715d                	addi	sp,sp,-80
    8000054e:	e486                	sd	ra,72(sp)
    80000550:	e0a2                	sd	s0,64(sp)
    80000552:	fc26                	sd	s1,56(sp)
    80000554:	f84a                	sd	s2,48(sp)
    80000556:	f44e                	sd	s3,40(sp)
    80000558:	f052                	sd	s4,32(sp)
    8000055a:	ec56                	sd	s5,24(sp)
    8000055c:	e85a                	sd	s6,16(sp)
    8000055e:	e45e                	sd	s7,8(sp)
    80000560:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    80000562:	c205                	beqz	a2,80000582 <mappages+0x36>
    80000564:	8aaa                	mv	s5,a0
    80000566:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80000568:	77fd                	lui	a5,0xfffff
    8000056a:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    8000056e:	15fd                	addi	a1,a1,-1
    80000570:	00c589b3          	add	s3,a1,a2
    80000574:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    80000578:	8952                	mv	s2,s4
    8000057a:	41468a33          	sub	s4,a3,s4
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    8000057e:	6b85                	lui	s7,0x1
    80000580:	a015                	j	800005a4 <mappages+0x58>
    panic("mappages: size");
    80000582:	00008517          	auipc	a0,0x8
    80000586:	ad650513          	addi	a0,a0,-1322 # 80008058 <etext+0x58>
    8000058a:	00006097          	auipc	ra,0x6
    8000058e:	8e8080e7          	jalr	-1816(ra) # 80005e72 <panic>
      panic("mappages: remap");
    80000592:	00008517          	auipc	a0,0x8
    80000596:	ad650513          	addi	a0,a0,-1322 # 80008068 <etext+0x68>
    8000059a:	00006097          	auipc	ra,0x6
    8000059e:	8d8080e7          	jalr	-1832(ra) # 80005e72 <panic>
    a += PGSIZE;
    800005a2:	995e                	add	s2,s2,s7
  for(;;){
    800005a4:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800005a8:	4605                	li	a2,1
    800005aa:	85ca                	mv	a1,s2
    800005ac:	8556                	mv	a0,s5
    800005ae:	00000097          	auipc	ra,0x0
    800005b2:	eb6080e7          	jalr	-330(ra) # 80000464 <walk>
    800005b6:	cd19                	beqz	a0,800005d4 <mappages+0x88>
    if(*pte & PTE_V)
    800005b8:	611c                	ld	a5,0(a0)
    800005ba:	8b85                	andi	a5,a5,1
    800005bc:	fbf9                	bnez	a5,80000592 <mappages+0x46>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800005be:	80b1                	srli	s1,s1,0xc
    800005c0:	04aa                	slli	s1,s1,0xa
    800005c2:	0164e4b3          	or	s1,s1,s6
    800005c6:	0014e493          	ori	s1,s1,1
    800005ca:	e104                	sd	s1,0(a0)
    if(a == last)
    800005cc:	fd391be3          	bne	s2,s3,800005a2 <mappages+0x56>
    pa += PGSIZE;
  }
  return 0;
    800005d0:	4501                	li	a0,0
    800005d2:	a011                	j	800005d6 <mappages+0x8a>
      return -1;
    800005d4:	557d                	li	a0,-1
}
    800005d6:	60a6                	ld	ra,72(sp)
    800005d8:	6406                	ld	s0,64(sp)
    800005da:	74e2                	ld	s1,56(sp)
    800005dc:	7942                	ld	s2,48(sp)
    800005de:	79a2                	ld	s3,40(sp)
    800005e0:	7a02                	ld	s4,32(sp)
    800005e2:	6ae2                	ld	s5,24(sp)
    800005e4:	6b42                	ld	s6,16(sp)
    800005e6:	6ba2                	ld	s7,8(sp)
    800005e8:	6161                	addi	sp,sp,80
    800005ea:	8082                	ret

00000000800005ec <kvmmap>:
{
    800005ec:	1141                	addi	sp,sp,-16
    800005ee:	e406                	sd	ra,8(sp)
    800005f0:	e022                	sd	s0,0(sp)
    800005f2:	0800                	addi	s0,sp,16
    800005f4:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800005f6:	86b2                	mv	a3,a2
    800005f8:	863e                	mv	a2,a5
    800005fa:	00000097          	auipc	ra,0x0
    800005fe:	f52080e7          	jalr	-174(ra) # 8000054c <mappages>
    80000602:	e509                	bnez	a0,8000060c <kvmmap+0x20>
}
    80000604:	60a2                	ld	ra,8(sp)
    80000606:	6402                	ld	s0,0(sp)
    80000608:	0141                	addi	sp,sp,16
    8000060a:	8082                	ret
    panic("kvmmap");
    8000060c:	00008517          	auipc	a0,0x8
    80000610:	a6c50513          	addi	a0,a0,-1428 # 80008078 <etext+0x78>
    80000614:	00006097          	auipc	ra,0x6
    80000618:	85e080e7          	jalr	-1954(ra) # 80005e72 <panic>

000000008000061c <kvmmake>:
{
    8000061c:	1101                	addi	sp,sp,-32
    8000061e:	ec06                	sd	ra,24(sp)
    80000620:	e822                	sd	s0,16(sp)
    80000622:	e426                	sd	s1,8(sp)
    80000624:	e04a                	sd	s2,0(sp)
    80000626:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000628:	00000097          	auipc	ra,0x0
    8000062c:	af0080e7          	jalr	-1296(ra) # 80000118 <kalloc>
    80000630:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000632:	6605                	lui	a2,0x1
    80000634:	4581                	li	a1,0
    80000636:	00000097          	auipc	ra,0x0
    8000063a:	b42080e7          	jalr	-1214(ra) # 80000178 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000063e:	4719                	li	a4,6
    80000640:	6685                	lui	a3,0x1
    80000642:	10000637          	lui	a2,0x10000
    80000646:	100005b7          	lui	a1,0x10000
    8000064a:	8526                	mv	a0,s1
    8000064c:	00000097          	auipc	ra,0x0
    80000650:	fa0080e7          	jalr	-96(ra) # 800005ec <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000654:	4719                	li	a4,6
    80000656:	6685                	lui	a3,0x1
    80000658:	10001637          	lui	a2,0x10001
    8000065c:	100015b7          	lui	a1,0x10001
    80000660:	8526                	mv	a0,s1
    80000662:	00000097          	auipc	ra,0x0
    80000666:	f8a080e7          	jalr	-118(ra) # 800005ec <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    8000066a:	4719                	li	a4,6
    8000066c:	004006b7          	lui	a3,0x400
    80000670:	0c000637          	lui	a2,0xc000
    80000674:	0c0005b7          	lui	a1,0xc000
    80000678:	8526                	mv	a0,s1
    8000067a:	00000097          	auipc	ra,0x0
    8000067e:	f72080e7          	jalr	-142(ra) # 800005ec <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80000682:	00008917          	auipc	s2,0x8
    80000686:	97e90913          	addi	s2,s2,-1666 # 80008000 <etext>
    8000068a:	4729                	li	a4,10
    8000068c:	80008697          	auipc	a3,0x80008
    80000690:	97468693          	addi	a3,a3,-1676 # 8000 <_entry-0x7fff8000>
    80000694:	4605                	li	a2,1
    80000696:	067e                	slli	a2,a2,0x1f
    80000698:	85b2                	mv	a1,a2
    8000069a:	8526                	mv	a0,s1
    8000069c:	00000097          	auipc	ra,0x0
    800006a0:	f50080e7          	jalr	-176(ra) # 800005ec <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006a4:	4719                	li	a4,6
    800006a6:	46c5                	li	a3,17
    800006a8:	06ee                	slli	a3,a3,0x1b
    800006aa:	412686b3          	sub	a3,a3,s2
    800006ae:	864a                	mv	a2,s2
    800006b0:	85ca                	mv	a1,s2
    800006b2:	8526                	mv	a0,s1
    800006b4:	00000097          	auipc	ra,0x0
    800006b8:	f38080e7          	jalr	-200(ra) # 800005ec <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006bc:	4729                	li	a4,10
    800006be:	6685                	lui	a3,0x1
    800006c0:	00007617          	auipc	a2,0x7
    800006c4:	94060613          	addi	a2,a2,-1728 # 80007000 <_trampoline>
    800006c8:	040005b7          	lui	a1,0x4000
    800006cc:	15fd                	addi	a1,a1,-1
    800006ce:	05b2                	slli	a1,a1,0xc
    800006d0:	8526                	mv	a0,s1
    800006d2:	00000097          	auipc	ra,0x0
    800006d6:	f1a080e7          	jalr	-230(ra) # 800005ec <kvmmap>
  proc_mapstacks(kpgtbl);
    800006da:	8526                	mv	a0,s1
    800006dc:	00000097          	auipc	ra,0x0
    800006e0:	6f2080e7          	jalr	1778(ra) # 80000dce <proc_mapstacks>
}
    800006e4:	8526                	mv	a0,s1
    800006e6:	60e2                	ld	ra,24(sp)
    800006e8:	6442                	ld	s0,16(sp)
    800006ea:	64a2                	ld	s1,8(sp)
    800006ec:	6902                	ld	s2,0(sp)
    800006ee:	6105                	addi	sp,sp,32
    800006f0:	8082                	ret

00000000800006f2 <kvminit>:
{
    800006f2:	1141                	addi	sp,sp,-16
    800006f4:	e406                	sd	ra,8(sp)
    800006f6:	e022                	sd	s0,0(sp)
    800006f8:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800006fa:	00000097          	auipc	ra,0x0
    800006fe:	f22080e7          	jalr	-222(ra) # 8000061c <kvmmake>
    80000702:	00008797          	auipc	a5,0x8
    80000706:	26a7b323          	sd	a0,614(a5) # 80008968 <kernel_pagetable>
}
    8000070a:	60a2                	ld	ra,8(sp)
    8000070c:	6402                	ld	s0,0(sp)
    8000070e:	0141                	addi	sp,sp,16
    80000710:	8082                	ret

0000000080000712 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000712:	715d                	addi	sp,sp,-80
    80000714:	e486                	sd	ra,72(sp)
    80000716:	e0a2                	sd	s0,64(sp)
    80000718:	fc26                	sd	s1,56(sp)
    8000071a:	f84a                	sd	s2,48(sp)
    8000071c:	f44e                	sd	s3,40(sp)
    8000071e:	f052                	sd	s4,32(sp)
    80000720:	ec56                	sd	s5,24(sp)
    80000722:	e85a                	sd	s6,16(sp)
    80000724:	e45e                	sd	s7,8(sp)
    80000726:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000728:	03459793          	slli	a5,a1,0x34
    8000072c:	e795                	bnez	a5,80000758 <uvmunmap+0x46>
    8000072e:	8a2a                	mv	s4,a0
    80000730:	892e                	mv	s2,a1
    80000732:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000734:	0632                	slli	a2,a2,0xc
    80000736:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    8000073a:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000073c:	6b05                	lui	s6,0x1
    8000073e:	0735e863          	bltu	a1,s3,800007ae <uvmunmap+0x9c>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80000742:	60a6                	ld	ra,72(sp)
    80000744:	6406                	ld	s0,64(sp)
    80000746:	74e2                	ld	s1,56(sp)
    80000748:	7942                	ld	s2,48(sp)
    8000074a:	79a2                	ld	s3,40(sp)
    8000074c:	7a02                	ld	s4,32(sp)
    8000074e:	6ae2                	ld	s5,24(sp)
    80000750:	6b42                	ld	s6,16(sp)
    80000752:	6ba2                	ld	s7,8(sp)
    80000754:	6161                	addi	sp,sp,80
    80000756:	8082                	ret
    panic("uvmunmap: not aligned");
    80000758:	00008517          	auipc	a0,0x8
    8000075c:	92850513          	addi	a0,a0,-1752 # 80008080 <etext+0x80>
    80000760:	00005097          	auipc	ra,0x5
    80000764:	712080e7          	jalr	1810(ra) # 80005e72 <panic>
      panic("uvmunmap: walk");
    80000768:	00008517          	auipc	a0,0x8
    8000076c:	93050513          	addi	a0,a0,-1744 # 80008098 <etext+0x98>
    80000770:	00005097          	auipc	ra,0x5
    80000774:	702080e7          	jalr	1794(ra) # 80005e72 <panic>
      panic("uvmunmap: not mapped");
    80000778:	00008517          	auipc	a0,0x8
    8000077c:	93050513          	addi	a0,a0,-1744 # 800080a8 <etext+0xa8>
    80000780:	00005097          	auipc	ra,0x5
    80000784:	6f2080e7          	jalr	1778(ra) # 80005e72 <panic>
      panic("uvmunmap: not a leaf");
    80000788:	00008517          	auipc	a0,0x8
    8000078c:	93850513          	addi	a0,a0,-1736 # 800080c0 <etext+0xc0>
    80000790:	00005097          	auipc	ra,0x5
    80000794:	6e2080e7          	jalr	1762(ra) # 80005e72 <panic>
      uint64 pa = PTE2PA(*pte);
    80000798:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    8000079a:	0532                	slli	a0,a0,0xc
    8000079c:	00000097          	auipc	ra,0x0
    800007a0:	880080e7          	jalr	-1920(ra) # 8000001c <kfree>
    *pte = 0;
    800007a4:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007a8:	995a                	add	s2,s2,s6
    800007aa:	f9397ce3          	bgeu	s2,s3,80000742 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800007ae:	4601                	li	a2,0
    800007b0:	85ca                	mv	a1,s2
    800007b2:	8552                	mv	a0,s4
    800007b4:	00000097          	auipc	ra,0x0
    800007b8:	cb0080e7          	jalr	-848(ra) # 80000464 <walk>
    800007bc:	84aa                	mv	s1,a0
    800007be:	d54d                	beqz	a0,80000768 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800007c0:	6108                	ld	a0,0(a0)
    800007c2:	00157793          	andi	a5,a0,1
    800007c6:	dbcd                	beqz	a5,80000778 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007c8:	3ff57793          	andi	a5,a0,1023
    800007cc:	fb778ee3          	beq	a5,s7,80000788 <uvmunmap+0x76>
    if(do_free){
    800007d0:	fc0a8ae3          	beqz	s5,800007a4 <uvmunmap+0x92>
    800007d4:	b7d1                	j	80000798 <uvmunmap+0x86>

00000000800007d6 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007d6:	1101                	addi	sp,sp,-32
    800007d8:	ec06                	sd	ra,24(sp)
    800007da:	e822                	sd	s0,16(sp)
    800007dc:	e426                	sd	s1,8(sp)
    800007de:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800007e0:	00000097          	auipc	ra,0x0
    800007e4:	938080e7          	jalr	-1736(ra) # 80000118 <kalloc>
    800007e8:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800007ea:	c519                	beqz	a0,800007f8 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800007ec:	6605                	lui	a2,0x1
    800007ee:	4581                	li	a1,0
    800007f0:	00000097          	auipc	ra,0x0
    800007f4:	988080e7          	jalr	-1656(ra) # 80000178 <memset>
  return pagetable;
}
    800007f8:	8526                	mv	a0,s1
    800007fa:	60e2                	ld	ra,24(sp)
    800007fc:	6442                	ld	s0,16(sp)
    800007fe:	64a2                	ld	s1,8(sp)
    80000800:	6105                	addi	sp,sp,32
    80000802:	8082                	ret

0000000080000804 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80000804:	7179                	addi	sp,sp,-48
    80000806:	f406                	sd	ra,40(sp)
    80000808:	f022                	sd	s0,32(sp)
    8000080a:	ec26                	sd	s1,24(sp)
    8000080c:	e84a                	sd	s2,16(sp)
    8000080e:	e44e                	sd	s3,8(sp)
    80000810:	e052                	sd	s4,0(sp)
    80000812:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000814:	6785                	lui	a5,0x1
    80000816:	04f67863          	bgeu	a2,a5,80000866 <uvmfirst+0x62>
    8000081a:	8a2a                	mv	s4,a0
    8000081c:	89ae                	mv	s3,a1
    8000081e:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80000820:	00000097          	auipc	ra,0x0
    80000824:	8f8080e7          	jalr	-1800(ra) # 80000118 <kalloc>
    80000828:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000082a:	6605                	lui	a2,0x1
    8000082c:	4581                	li	a1,0
    8000082e:	00000097          	auipc	ra,0x0
    80000832:	94a080e7          	jalr	-1718(ra) # 80000178 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000836:	4779                	li	a4,30
    80000838:	86ca                	mv	a3,s2
    8000083a:	6605                	lui	a2,0x1
    8000083c:	4581                	li	a1,0
    8000083e:	8552                	mv	a0,s4
    80000840:	00000097          	auipc	ra,0x0
    80000844:	d0c080e7          	jalr	-756(ra) # 8000054c <mappages>
  memmove(mem, src, sz);
    80000848:	8626                	mv	a2,s1
    8000084a:	85ce                	mv	a1,s3
    8000084c:	854a                	mv	a0,s2
    8000084e:	00000097          	auipc	ra,0x0
    80000852:	98a080e7          	jalr	-1654(ra) # 800001d8 <memmove>
}
    80000856:	70a2                	ld	ra,40(sp)
    80000858:	7402                	ld	s0,32(sp)
    8000085a:	64e2                	ld	s1,24(sp)
    8000085c:	6942                	ld	s2,16(sp)
    8000085e:	69a2                	ld	s3,8(sp)
    80000860:	6a02                	ld	s4,0(sp)
    80000862:	6145                	addi	sp,sp,48
    80000864:	8082                	ret
    panic("uvmfirst: more than a page");
    80000866:	00008517          	auipc	a0,0x8
    8000086a:	87250513          	addi	a0,a0,-1934 # 800080d8 <etext+0xd8>
    8000086e:	00005097          	auipc	ra,0x5
    80000872:	604080e7          	jalr	1540(ra) # 80005e72 <panic>

0000000080000876 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000876:	1101                	addi	sp,sp,-32
    80000878:	ec06                	sd	ra,24(sp)
    8000087a:	e822                	sd	s0,16(sp)
    8000087c:	e426                	sd	s1,8(sp)
    8000087e:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80000880:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80000882:	00b67d63          	bgeu	a2,a1,8000089c <uvmdealloc+0x26>
    80000886:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000888:	6785                	lui	a5,0x1
    8000088a:	17fd                	addi	a5,a5,-1
    8000088c:	00f60733          	add	a4,a2,a5
    80000890:	767d                	lui	a2,0xfffff
    80000892:	8f71                	and	a4,a4,a2
    80000894:	97ae                	add	a5,a5,a1
    80000896:	8ff1                	and	a5,a5,a2
    80000898:	00f76863          	bltu	a4,a5,800008a8 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    8000089c:	8526                	mv	a0,s1
    8000089e:	60e2                	ld	ra,24(sp)
    800008a0:	6442                	ld	s0,16(sp)
    800008a2:	64a2                	ld	s1,8(sp)
    800008a4:	6105                	addi	sp,sp,32
    800008a6:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008a8:	8f99                	sub	a5,a5,a4
    800008aa:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008ac:	4685                	li	a3,1
    800008ae:	0007861b          	sext.w	a2,a5
    800008b2:	85ba                	mv	a1,a4
    800008b4:	00000097          	auipc	ra,0x0
    800008b8:	e5e080e7          	jalr	-418(ra) # 80000712 <uvmunmap>
    800008bc:	b7c5                	j	8000089c <uvmdealloc+0x26>

00000000800008be <uvmalloc>:
  if(newsz < oldsz)
    800008be:	0ab66563          	bltu	a2,a1,80000968 <uvmalloc+0xaa>
{
    800008c2:	7139                	addi	sp,sp,-64
    800008c4:	fc06                	sd	ra,56(sp)
    800008c6:	f822                	sd	s0,48(sp)
    800008c8:	f426                	sd	s1,40(sp)
    800008ca:	f04a                	sd	s2,32(sp)
    800008cc:	ec4e                	sd	s3,24(sp)
    800008ce:	e852                	sd	s4,16(sp)
    800008d0:	e456                	sd	s5,8(sp)
    800008d2:	e05a                	sd	s6,0(sp)
    800008d4:	0080                	addi	s0,sp,64
    800008d6:	8aaa                	mv	s5,a0
    800008d8:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008da:	6985                	lui	s3,0x1
    800008dc:	19fd                	addi	s3,s3,-1
    800008de:	95ce                	add	a1,a1,s3
    800008e0:	79fd                	lui	s3,0xfffff
    800008e2:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    800008e6:	08c9f363          	bgeu	s3,a2,8000096c <uvmalloc+0xae>
    800008ea:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800008ec:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    800008f0:	00000097          	auipc	ra,0x0
    800008f4:	828080e7          	jalr	-2008(ra) # 80000118 <kalloc>
    800008f8:	84aa                	mv	s1,a0
    if(mem == 0){
    800008fa:	c51d                	beqz	a0,80000928 <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    800008fc:	6605                	lui	a2,0x1
    800008fe:	4581                	li	a1,0
    80000900:	00000097          	auipc	ra,0x0
    80000904:	878080e7          	jalr	-1928(ra) # 80000178 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000908:	875a                	mv	a4,s6
    8000090a:	86a6                	mv	a3,s1
    8000090c:	6605                	lui	a2,0x1
    8000090e:	85ca                	mv	a1,s2
    80000910:	8556                	mv	a0,s5
    80000912:	00000097          	auipc	ra,0x0
    80000916:	c3a080e7          	jalr	-966(ra) # 8000054c <mappages>
    8000091a:	e90d                	bnez	a0,8000094c <uvmalloc+0x8e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000091c:	6785                	lui	a5,0x1
    8000091e:	993e                	add	s2,s2,a5
    80000920:	fd4968e3          	bltu	s2,s4,800008f0 <uvmalloc+0x32>
  return newsz;
    80000924:	8552                	mv	a0,s4
    80000926:	a809                	j	80000938 <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    80000928:	864e                	mv	a2,s3
    8000092a:	85ca                	mv	a1,s2
    8000092c:	8556                	mv	a0,s5
    8000092e:	00000097          	auipc	ra,0x0
    80000932:	f48080e7          	jalr	-184(ra) # 80000876 <uvmdealloc>
      return 0;
    80000936:	4501                	li	a0,0
}
    80000938:	70e2                	ld	ra,56(sp)
    8000093a:	7442                	ld	s0,48(sp)
    8000093c:	74a2                	ld	s1,40(sp)
    8000093e:	7902                	ld	s2,32(sp)
    80000940:	69e2                	ld	s3,24(sp)
    80000942:	6a42                	ld	s4,16(sp)
    80000944:	6aa2                	ld	s5,8(sp)
    80000946:	6b02                	ld	s6,0(sp)
    80000948:	6121                	addi	sp,sp,64
    8000094a:	8082                	ret
      kfree(mem);
    8000094c:	8526                	mv	a0,s1
    8000094e:	fffff097          	auipc	ra,0xfffff
    80000952:	6ce080e7          	jalr	1742(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000956:	864e                	mv	a2,s3
    80000958:	85ca                	mv	a1,s2
    8000095a:	8556                	mv	a0,s5
    8000095c:	00000097          	auipc	ra,0x0
    80000960:	f1a080e7          	jalr	-230(ra) # 80000876 <uvmdealloc>
      return 0;
    80000964:	4501                	li	a0,0
    80000966:	bfc9                	j	80000938 <uvmalloc+0x7a>
    return oldsz;
    80000968:	852e                	mv	a0,a1
}
    8000096a:	8082                	ret
  return newsz;
    8000096c:	8532                	mv	a0,a2
    8000096e:	b7e9                	j	80000938 <uvmalloc+0x7a>

0000000080000970 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000970:	7179                	addi	sp,sp,-48
    80000972:	f406                	sd	ra,40(sp)
    80000974:	f022                	sd	s0,32(sp)
    80000976:	ec26                	sd	s1,24(sp)
    80000978:	e84a                	sd	s2,16(sp)
    8000097a:	e44e                	sd	s3,8(sp)
    8000097c:	e052                	sd	s4,0(sp)
    8000097e:	1800                	addi	s0,sp,48
    80000980:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000982:	84aa                	mv	s1,a0
    80000984:	6905                	lui	s2,0x1
    80000986:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000988:	4985                	li	s3,1
    8000098a:	a821                	j	800009a2 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    8000098c:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    8000098e:	0532                	slli	a0,a0,0xc
    80000990:	00000097          	auipc	ra,0x0
    80000994:	fe0080e7          	jalr	-32(ra) # 80000970 <freewalk>
      pagetable[i] = 0;
    80000998:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    8000099c:	04a1                	addi	s1,s1,8
    8000099e:	03248163          	beq	s1,s2,800009c0 <freewalk+0x50>
    pte_t pte = pagetable[i];
    800009a2:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009a4:	00f57793          	andi	a5,a0,15
    800009a8:	ff3782e3          	beq	a5,s3,8000098c <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009ac:	8905                	andi	a0,a0,1
    800009ae:	d57d                	beqz	a0,8000099c <freewalk+0x2c>
      panic("freewalk: leaf");
    800009b0:	00007517          	auipc	a0,0x7
    800009b4:	74850513          	addi	a0,a0,1864 # 800080f8 <etext+0xf8>
    800009b8:	00005097          	auipc	ra,0x5
    800009bc:	4ba080e7          	jalr	1210(ra) # 80005e72 <panic>
    }
  }
  kfree((void*)pagetable);
    800009c0:	8552                	mv	a0,s4
    800009c2:	fffff097          	auipc	ra,0xfffff
    800009c6:	65a080e7          	jalr	1626(ra) # 8000001c <kfree>
}
    800009ca:	70a2                	ld	ra,40(sp)
    800009cc:	7402                	ld	s0,32(sp)
    800009ce:	64e2                	ld	s1,24(sp)
    800009d0:	6942                	ld	s2,16(sp)
    800009d2:	69a2                	ld	s3,8(sp)
    800009d4:	6a02                	ld	s4,0(sp)
    800009d6:	6145                	addi	sp,sp,48
    800009d8:	8082                	ret

00000000800009da <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009da:	1101                	addi	sp,sp,-32
    800009dc:	ec06                	sd	ra,24(sp)
    800009de:	e822                	sd	s0,16(sp)
    800009e0:	e426                	sd	s1,8(sp)
    800009e2:	1000                	addi	s0,sp,32
    800009e4:	84aa                	mv	s1,a0
  if(sz > 0)
    800009e6:	e999                	bnez	a1,800009fc <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800009e8:	8526                	mv	a0,s1
    800009ea:	00000097          	auipc	ra,0x0
    800009ee:	f86080e7          	jalr	-122(ra) # 80000970 <freewalk>
}
    800009f2:	60e2                	ld	ra,24(sp)
    800009f4:	6442                	ld	s0,16(sp)
    800009f6:	64a2                	ld	s1,8(sp)
    800009f8:	6105                	addi	sp,sp,32
    800009fa:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800009fc:	6605                	lui	a2,0x1
    800009fe:	167d                	addi	a2,a2,-1
    80000a00:	962e                	add	a2,a2,a1
    80000a02:	4685                	li	a3,1
    80000a04:	8231                	srli	a2,a2,0xc
    80000a06:	4581                	li	a1,0
    80000a08:	00000097          	auipc	ra,0x0
    80000a0c:	d0a080e7          	jalr	-758(ra) # 80000712 <uvmunmap>
    80000a10:	bfe1                	j	800009e8 <uvmfree+0xe>

0000000080000a12 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a12:	c679                	beqz	a2,80000ae0 <uvmcopy+0xce>
{
    80000a14:	715d                	addi	sp,sp,-80
    80000a16:	e486                	sd	ra,72(sp)
    80000a18:	e0a2                	sd	s0,64(sp)
    80000a1a:	fc26                	sd	s1,56(sp)
    80000a1c:	f84a                	sd	s2,48(sp)
    80000a1e:	f44e                	sd	s3,40(sp)
    80000a20:	f052                	sd	s4,32(sp)
    80000a22:	ec56                	sd	s5,24(sp)
    80000a24:	e85a                	sd	s6,16(sp)
    80000a26:	e45e                	sd	s7,8(sp)
    80000a28:	0880                	addi	s0,sp,80
    80000a2a:	8b2a                	mv	s6,a0
    80000a2c:	8aae                	mv	s5,a1
    80000a2e:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a30:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a32:	4601                	li	a2,0
    80000a34:	85ce                	mv	a1,s3
    80000a36:	855a                	mv	a0,s6
    80000a38:	00000097          	auipc	ra,0x0
    80000a3c:	a2c080e7          	jalr	-1492(ra) # 80000464 <walk>
    80000a40:	c531                	beqz	a0,80000a8c <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a42:	6118                	ld	a4,0(a0)
    80000a44:	00177793          	andi	a5,a4,1
    80000a48:	cbb1                	beqz	a5,80000a9c <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a4a:	00a75593          	srli	a1,a4,0xa
    80000a4e:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a52:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a56:	fffff097          	auipc	ra,0xfffff
    80000a5a:	6c2080e7          	jalr	1730(ra) # 80000118 <kalloc>
    80000a5e:	892a                	mv	s2,a0
    80000a60:	c939                	beqz	a0,80000ab6 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a62:	6605                	lui	a2,0x1
    80000a64:	85de                	mv	a1,s7
    80000a66:	fffff097          	auipc	ra,0xfffff
    80000a6a:	772080e7          	jalr	1906(ra) # 800001d8 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a6e:	8726                	mv	a4,s1
    80000a70:	86ca                	mv	a3,s2
    80000a72:	6605                	lui	a2,0x1
    80000a74:	85ce                	mv	a1,s3
    80000a76:	8556                	mv	a0,s5
    80000a78:	00000097          	auipc	ra,0x0
    80000a7c:	ad4080e7          	jalr	-1324(ra) # 8000054c <mappages>
    80000a80:	e515                	bnez	a0,80000aac <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000a82:	6785                	lui	a5,0x1
    80000a84:	99be                	add	s3,s3,a5
    80000a86:	fb49e6e3          	bltu	s3,s4,80000a32 <uvmcopy+0x20>
    80000a8a:	a081                	j	80000aca <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000a8c:	00007517          	auipc	a0,0x7
    80000a90:	67c50513          	addi	a0,a0,1660 # 80008108 <etext+0x108>
    80000a94:	00005097          	auipc	ra,0x5
    80000a98:	3de080e7          	jalr	990(ra) # 80005e72 <panic>
      panic("uvmcopy: page not present");
    80000a9c:	00007517          	auipc	a0,0x7
    80000aa0:	68c50513          	addi	a0,a0,1676 # 80008128 <etext+0x128>
    80000aa4:	00005097          	auipc	ra,0x5
    80000aa8:	3ce080e7          	jalr	974(ra) # 80005e72 <panic>
      kfree(mem);
    80000aac:	854a                	mv	a0,s2
    80000aae:	fffff097          	auipc	ra,0xfffff
    80000ab2:	56e080e7          	jalr	1390(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000ab6:	4685                	li	a3,1
    80000ab8:	00c9d613          	srli	a2,s3,0xc
    80000abc:	4581                	li	a1,0
    80000abe:	8556                	mv	a0,s5
    80000ac0:	00000097          	auipc	ra,0x0
    80000ac4:	c52080e7          	jalr	-942(ra) # 80000712 <uvmunmap>
  return -1;
    80000ac8:	557d                	li	a0,-1
}
    80000aca:	60a6                	ld	ra,72(sp)
    80000acc:	6406                	ld	s0,64(sp)
    80000ace:	74e2                	ld	s1,56(sp)
    80000ad0:	7942                	ld	s2,48(sp)
    80000ad2:	79a2                	ld	s3,40(sp)
    80000ad4:	7a02                	ld	s4,32(sp)
    80000ad6:	6ae2                	ld	s5,24(sp)
    80000ad8:	6b42                	ld	s6,16(sp)
    80000ada:	6ba2                	ld	s7,8(sp)
    80000adc:	6161                	addi	sp,sp,80
    80000ade:	8082                	ret
  return 0;
    80000ae0:	4501                	li	a0,0
}
    80000ae2:	8082                	ret

0000000080000ae4 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000ae4:	1141                	addi	sp,sp,-16
    80000ae6:	e406                	sd	ra,8(sp)
    80000ae8:	e022                	sd	s0,0(sp)
    80000aea:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000aec:	4601                	li	a2,0
    80000aee:	00000097          	auipc	ra,0x0
    80000af2:	976080e7          	jalr	-1674(ra) # 80000464 <walk>
  if(pte == 0)
    80000af6:	c901                	beqz	a0,80000b06 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000af8:	611c                	ld	a5,0(a0)
    80000afa:	9bbd                	andi	a5,a5,-17
    80000afc:	e11c                	sd	a5,0(a0)
}
    80000afe:	60a2                	ld	ra,8(sp)
    80000b00:	6402                	ld	s0,0(sp)
    80000b02:	0141                	addi	sp,sp,16
    80000b04:	8082                	ret
    panic("uvmclear");
    80000b06:	00007517          	auipc	a0,0x7
    80000b0a:	64250513          	addi	a0,a0,1602 # 80008148 <etext+0x148>
    80000b0e:	00005097          	auipc	ra,0x5
    80000b12:	364080e7          	jalr	868(ra) # 80005e72 <panic>

0000000080000b16 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b16:	c6bd                	beqz	a3,80000b84 <copyout+0x6e>
{
    80000b18:	715d                	addi	sp,sp,-80
    80000b1a:	e486                	sd	ra,72(sp)
    80000b1c:	e0a2                	sd	s0,64(sp)
    80000b1e:	fc26                	sd	s1,56(sp)
    80000b20:	f84a                	sd	s2,48(sp)
    80000b22:	f44e                	sd	s3,40(sp)
    80000b24:	f052                	sd	s4,32(sp)
    80000b26:	ec56                	sd	s5,24(sp)
    80000b28:	e85a                	sd	s6,16(sp)
    80000b2a:	e45e                	sd	s7,8(sp)
    80000b2c:	e062                	sd	s8,0(sp)
    80000b2e:	0880                	addi	s0,sp,80
    80000b30:	8b2a                	mv	s6,a0
    80000b32:	8c2e                	mv	s8,a1
    80000b34:	8a32                	mv	s4,a2
    80000b36:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b38:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b3a:	6a85                	lui	s5,0x1
    80000b3c:	a015                	j	80000b60 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b3e:	9562                	add	a0,a0,s8
    80000b40:	0004861b          	sext.w	a2,s1
    80000b44:	85d2                	mv	a1,s4
    80000b46:	41250533          	sub	a0,a0,s2
    80000b4a:	fffff097          	auipc	ra,0xfffff
    80000b4e:	68e080e7          	jalr	1678(ra) # 800001d8 <memmove>

    len -= n;
    80000b52:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b56:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b58:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b5c:	02098263          	beqz	s3,80000b80 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b60:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b64:	85ca                	mv	a1,s2
    80000b66:	855a                	mv	a0,s6
    80000b68:	00000097          	auipc	ra,0x0
    80000b6c:	9a2080e7          	jalr	-1630(ra) # 8000050a <walkaddr>
    if(pa0 == 0)
    80000b70:	cd01                	beqz	a0,80000b88 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000b72:	418904b3          	sub	s1,s2,s8
    80000b76:	94d6                	add	s1,s1,s5
    if(n > len)
    80000b78:	fc99f3e3          	bgeu	s3,s1,80000b3e <copyout+0x28>
    80000b7c:	84ce                	mv	s1,s3
    80000b7e:	b7c1                	j	80000b3e <copyout+0x28>
  }
  return 0;
    80000b80:	4501                	li	a0,0
    80000b82:	a021                	j	80000b8a <copyout+0x74>
    80000b84:	4501                	li	a0,0
}
    80000b86:	8082                	ret
      return -1;
    80000b88:	557d                	li	a0,-1
}
    80000b8a:	60a6                	ld	ra,72(sp)
    80000b8c:	6406                	ld	s0,64(sp)
    80000b8e:	74e2                	ld	s1,56(sp)
    80000b90:	7942                	ld	s2,48(sp)
    80000b92:	79a2                	ld	s3,40(sp)
    80000b94:	7a02                	ld	s4,32(sp)
    80000b96:	6ae2                	ld	s5,24(sp)
    80000b98:	6b42                	ld	s6,16(sp)
    80000b9a:	6ba2                	ld	s7,8(sp)
    80000b9c:	6c02                	ld	s8,0(sp)
    80000b9e:	6161                	addi	sp,sp,80
    80000ba0:	8082                	ret

0000000080000ba2 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000ba2:	c6bd                	beqz	a3,80000c10 <copyin+0x6e>
{
    80000ba4:	715d                	addi	sp,sp,-80
    80000ba6:	e486                	sd	ra,72(sp)
    80000ba8:	e0a2                	sd	s0,64(sp)
    80000baa:	fc26                	sd	s1,56(sp)
    80000bac:	f84a                	sd	s2,48(sp)
    80000bae:	f44e                	sd	s3,40(sp)
    80000bb0:	f052                	sd	s4,32(sp)
    80000bb2:	ec56                	sd	s5,24(sp)
    80000bb4:	e85a                	sd	s6,16(sp)
    80000bb6:	e45e                	sd	s7,8(sp)
    80000bb8:	e062                	sd	s8,0(sp)
    80000bba:	0880                	addi	s0,sp,80
    80000bbc:	8b2a                	mv	s6,a0
    80000bbe:	8a2e                	mv	s4,a1
    80000bc0:	8c32                	mv	s8,a2
    80000bc2:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000bc4:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000bc6:	6a85                	lui	s5,0x1
    80000bc8:	a015                	j	80000bec <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000bca:	9562                	add	a0,a0,s8
    80000bcc:	0004861b          	sext.w	a2,s1
    80000bd0:	412505b3          	sub	a1,a0,s2
    80000bd4:	8552                	mv	a0,s4
    80000bd6:	fffff097          	auipc	ra,0xfffff
    80000bda:	602080e7          	jalr	1538(ra) # 800001d8 <memmove>

    len -= n;
    80000bde:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000be2:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000be4:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000be8:	02098263          	beqz	s3,80000c0c <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80000bec:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000bf0:	85ca                	mv	a1,s2
    80000bf2:	855a                	mv	a0,s6
    80000bf4:	00000097          	auipc	ra,0x0
    80000bf8:	916080e7          	jalr	-1770(ra) # 8000050a <walkaddr>
    if(pa0 == 0)
    80000bfc:	cd01                	beqz	a0,80000c14 <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80000bfe:	418904b3          	sub	s1,s2,s8
    80000c02:	94d6                	add	s1,s1,s5
    if(n > len)
    80000c04:	fc99f3e3          	bgeu	s3,s1,80000bca <copyin+0x28>
    80000c08:	84ce                	mv	s1,s3
    80000c0a:	b7c1                	j	80000bca <copyin+0x28>
  }
  return 0;
    80000c0c:	4501                	li	a0,0
    80000c0e:	a021                	j	80000c16 <copyin+0x74>
    80000c10:	4501                	li	a0,0
}
    80000c12:	8082                	ret
      return -1;
    80000c14:	557d                	li	a0,-1
}
    80000c16:	60a6                	ld	ra,72(sp)
    80000c18:	6406                	ld	s0,64(sp)
    80000c1a:	74e2                	ld	s1,56(sp)
    80000c1c:	7942                	ld	s2,48(sp)
    80000c1e:	79a2                	ld	s3,40(sp)
    80000c20:	7a02                	ld	s4,32(sp)
    80000c22:	6ae2                	ld	s5,24(sp)
    80000c24:	6b42                	ld	s6,16(sp)
    80000c26:	6ba2                	ld	s7,8(sp)
    80000c28:	6c02                	ld	s8,0(sp)
    80000c2a:	6161                	addi	sp,sp,80
    80000c2c:	8082                	ret

0000000080000c2e <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c2e:	c6c5                	beqz	a3,80000cd6 <copyinstr+0xa8>
{
    80000c30:	715d                	addi	sp,sp,-80
    80000c32:	e486                	sd	ra,72(sp)
    80000c34:	e0a2                	sd	s0,64(sp)
    80000c36:	fc26                	sd	s1,56(sp)
    80000c38:	f84a                	sd	s2,48(sp)
    80000c3a:	f44e                	sd	s3,40(sp)
    80000c3c:	f052                	sd	s4,32(sp)
    80000c3e:	ec56                	sd	s5,24(sp)
    80000c40:	e85a                	sd	s6,16(sp)
    80000c42:	e45e                	sd	s7,8(sp)
    80000c44:	0880                	addi	s0,sp,80
    80000c46:	8a2a                	mv	s4,a0
    80000c48:	8b2e                	mv	s6,a1
    80000c4a:	8bb2                	mv	s7,a2
    80000c4c:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c4e:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c50:	6985                	lui	s3,0x1
    80000c52:	a035                	j	80000c7e <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c54:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c58:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c5a:	0017b793          	seqz	a5,a5
    80000c5e:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c62:	60a6                	ld	ra,72(sp)
    80000c64:	6406                	ld	s0,64(sp)
    80000c66:	74e2                	ld	s1,56(sp)
    80000c68:	7942                	ld	s2,48(sp)
    80000c6a:	79a2                	ld	s3,40(sp)
    80000c6c:	7a02                	ld	s4,32(sp)
    80000c6e:	6ae2                	ld	s5,24(sp)
    80000c70:	6b42                	ld	s6,16(sp)
    80000c72:	6ba2                	ld	s7,8(sp)
    80000c74:	6161                	addi	sp,sp,80
    80000c76:	8082                	ret
    srcva = va0 + PGSIZE;
    80000c78:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000c7c:	c8a9                	beqz	s1,80000cce <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000c7e:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000c82:	85ca                	mv	a1,s2
    80000c84:	8552                	mv	a0,s4
    80000c86:	00000097          	auipc	ra,0x0
    80000c8a:	884080e7          	jalr	-1916(ra) # 8000050a <walkaddr>
    if(pa0 == 0)
    80000c8e:	c131                	beqz	a0,80000cd2 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000c90:	41790833          	sub	a6,s2,s7
    80000c94:	984e                	add	a6,a6,s3
    if(n > max)
    80000c96:	0104f363          	bgeu	s1,a6,80000c9c <copyinstr+0x6e>
    80000c9a:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000c9c:	955e                	add	a0,a0,s7
    80000c9e:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000ca2:	fc080be3          	beqz	a6,80000c78 <copyinstr+0x4a>
    80000ca6:	985a                	add	a6,a6,s6
    80000ca8:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000caa:	41650633          	sub	a2,a0,s6
    80000cae:	14fd                	addi	s1,s1,-1
    80000cb0:	9b26                	add	s6,s6,s1
    80000cb2:	00f60733          	add	a4,a2,a5
    80000cb6:	00074703          	lbu	a4,0(a4)
    80000cba:	df49                	beqz	a4,80000c54 <copyinstr+0x26>
        *dst = *p;
    80000cbc:	00e78023          	sb	a4,0(a5)
      --max;
    80000cc0:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000cc4:	0785                	addi	a5,a5,1
    while(n > 0){
    80000cc6:	ff0796e3          	bne	a5,a6,80000cb2 <copyinstr+0x84>
      dst++;
    80000cca:	8b42                	mv	s6,a6
    80000ccc:	b775                	j	80000c78 <copyinstr+0x4a>
    80000cce:	4781                	li	a5,0
    80000cd0:	b769                	j	80000c5a <copyinstr+0x2c>
      return -1;
    80000cd2:	557d                	li	a0,-1
    80000cd4:	b779                	j	80000c62 <copyinstr+0x34>
  int got_null = 0;
    80000cd6:	4781                	li	a5,0
  if(got_null){
    80000cd8:	0017b793          	seqz	a5,a5
    80000cdc:	40f00533          	neg	a0,a5
}
    80000ce0:	8082                	ret

0000000080000ce2 <vmprint>:
////////////////////////////////////////////////
//1.增加vmprint函数
//2.修改exec函数（just before the return argc）
//3.在defs.h文件中定义vmprint()
//4.完成vmprint函数
void vmprint(pagetable_t pagetable){
    80000ce2:	7159                	addi	sp,sp,-112
    80000ce4:	f486                	sd	ra,104(sp)
    80000ce6:	f0a2                	sd	s0,96(sp)
    80000ce8:	eca6                	sd	s1,88(sp)
    80000cea:	e8ca                	sd	s2,80(sp)
    80000cec:	e4ce                	sd	s3,72(sp)
    80000cee:	e0d2                	sd	s4,64(sp)
    80000cf0:	fc56                	sd	s5,56(sp)
    80000cf2:	f85a                	sd	s6,48(sp)
    80000cf4:	f45e                	sd	s7,40(sp)
    80000cf6:	f062                	sd	s8,32(sp)
    80000cf8:	ec66                	sd	s9,24(sp)
    80000cfa:	e86a                	sd	s10,16(sp)
    80000cfc:	e46e                	sd	s11,8(sp)
    80000cfe:	1880                	addi	s0,sp,112
    80000d00:	8baa                	mv	s7,a0
  printf("page table %p\n", pagetable);
    80000d02:	85aa                	mv	a1,a0
    80000d04:	00007517          	auipc	a0,0x7
    80000d08:	45450513          	addi	a0,a0,1108 # 80008158 <etext+0x158>
    80000d0c:	00005097          	auipc	ra,0x5
    80000d10:	1b0080e7          	jalr	432(ra) # 80005ebc <printf>
  //顶级页表,512项
  for(int i = 0; i < 512; i++){
    80000d14:	4c01                	li	s8,0
    pte_t pte = pagetable[i];
    if(pte & PTE_V){
      printf("..%d: pte %p pa %p\n", i, pte, PTE2PA(pte));
    80000d16:	00007d97          	auipc	s11,0x7
    80000d1a:	452d8d93          	addi	s11,s11,1106 # 80008168 <etext+0x168>
      uint64 child = PTE2PA(pte);
      //二级页表
      for(int j = 0; j < 512; j++){
        pte_t pte1 = ((pagetable_t)child)[j];
        if(pte1 & PTE_V){
          printf(".. ..%d: pte %p pa %p\n", j, pte1, PTE2PA(pte1));
    80000d1e:	00007d17          	auipc	s10,0x7
    80000d22:	462d0d13          	addi	s10,s10,1122 # 80008180 <etext+0x180>
          uint64 child1 = PTE2PA(pte1);
          //三级页表
          for(int k = 0; k < 512; k++){
    80000d26:	20000993          	li	s3,512
    80000d2a:	4c81                	li	s9,0
            pte_t pte2 = ((pagetable_t)child1)[k];
            if(pte2 & PTE_V){
              printf(".. .. ..%d: pte %p pa %p\n", k, pte2, PTE2PA(pte2));
    80000d2c:	00007a17          	auipc	s4,0x7
    80000d30:	46ca0a13          	addi	s4,s4,1132 # 80008198 <etext+0x198>
    80000d34:	a8a9                	j	80000d8e <vmprint+0xac>
    80000d36:	00a65693          	srli	a3,a2,0xa
    80000d3a:	06b2                	slli	a3,a3,0xc
    80000d3c:	85a6                	mv	a1,s1
    80000d3e:	8552                	mv	a0,s4
    80000d40:	00005097          	auipc	ra,0x5
    80000d44:	17c080e7          	jalr	380(ra) # 80005ebc <printf>
          for(int k = 0; k < 512; k++){
    80000d48:	2485                	addiw	s1,s1,1
    80000d4a:	0921                	addi	s2,s2,8
    80000d4c:	01348863          	beq	s1,s3,80000d5c <vmprint+0x7a>
            pte_t pte2 = ((pagetable_t)child1)[k];
    80000d50:	00093603          	ld	a2,0(s2) # 1000 <_entry-0x7ffff000>
            if(pte2 & PTE_V){
    80000d54:	00167793          	andi	a5,a2,1
    80000d58:	dbe5                	beqz	a5,80000d48 <vmprint+0x66>
    80000d5a:	bff1                	j	80000d36 <vmprint+0x54>
      for(int j = 0; j < 512; j++){
    80000d5c:	2a85                	addiw	s5,s5,1
    80000d5e:	0b21                	addi	s6,s6,8
    80000d60:	033a8363          	beq	s5,s3,80000d86 <vmprint+0xa4>
        pte_t pte1 = ((pagetable_t)child)[j];
    80000d64:	000b3603          	ld	a2,0(s6) # 1000 <_entry-0x7ffff000>
        if(pte1 & PTE_V){
    80000d68:	00167793          	andi	a5,a2,1
    80000d6c:	dbe5                	beqz	a5,80000d5c <vmprint+0x7a>
          printf(".. ..%d: pte %p pa %p\n", j, pte1, PTE2PA(pte1));
    80000d6e:	00a65913          	srli	s2,a2,0xa
    80000d72:	0932                	slli	s2,s2,0xc
    80000d74:	86ca                	mv	a3,s2
    80000d76:	85d6                	mv	a1,s5
    80000d78:	856a                	mv	a0,s10
    80000d7a:	00005097          	auipc	ra,0x5
    80000d7e:	142080e7          	jalr	322(ra) # 80005ebc <printf>
          for(int k = 0; k < 512; k++){
    80000d82:	84e6                	mv	s1,s9
    80000d84:	b7f1                	j	80000d50 <vmprint+0x6e>
  for(int i = 0; i < 512; i++){
    80000d86:	2c05                	addiw	s8,s8,1
    80000d88:	0ba1                	addi	s7,s7,8
    80000d8a:	033c0363          	beq	s8,s3,80000db0 <vmprint+0xce>
    pte_t pte = pagetable[i];
    80000d8e:	000bb603          	ld	a2,0(s7) # fffffffffffff000 <end+0xffffffff7ffdd000>
    if(pte & PTE_V){
    80000d92:	00167793          	andi	a5,a2,1
    80000d96:	dbe5                	beqz	a5,80000d86 <vmprint+0xa4>
      printf("..%d: pte %p pa %p\n", i, pte, PTE2PA(pte));
    80000d98:	00a65b13          	srli	s6,a2,0xa
    80000d9c:	0b32                	slli	s6,s6,0xc
    80000d9e:	86da                	mv	a3,s6
    80000da0:	85e2                	mv	a1,s8
    80000da2:	856e                	mv	a0,s11
    80000da4:	00005097          	auipc	ra,0x5
    80000da8:	118080e7          	jalr	280(ra) # 80005ebc <printf>
      for(int j = 0; j < 512; j++){
    80000dac:	4a81                	li	s5,0
    80000dae:	bf5d                	j	80000d64 <vmprint+0x82>
    //       }
    //     }
    //   }
    // }
    // }
}
    80000db0:	70a6                	ld	ra,104(sp)
    80000db2:	7406                	ld	s0,96(sp)
    80000db4:	64e6                	ld	s1,88(sp)
    80000db6:	6946                	ld	s2,80(sp)
    80000db8:	69a6                	ld	s3,72(sp)
    80000dba:	6a06                	ld	s4,64(sp)
    80000dbc:	7ae2                	ld	s5,56(sp)
    80000dbe:	7b42                	ld	s6,48(sp)
    80000dc0:	7ba2                	ld	s7,40(sp)
    80000dc2:	7c02                	ld	s8,32(sp)
    80000dc4:	6ce2                	ld	s9,24(sp)
    80000dc6:	6d42                	ld	s10,16(sp)
    80000dc8:	6da2                	ld	s11,8(sp)
    80000dca:	6165                	addi	sp,sp,112
    80000dcc:	8082                	ret

0000000080000dce <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000dce:	7139                	addi	sp,sp,-64
    80000dd0:	fc06                	sd	ra,56(sp)
    80000dd2:	f822                	sd	s0,48(sp)
    80000dd4:	f426                	sd	s1,40(sp)
    80000dd6:	f04a                	sd	s2,32(sp)
    80000dd8:	ec4e                	sd	s3,24(sp)
    80000dda:	e852                	sd	s4,16(sp)
    80000ddc:	e456                	sd	s5,8(sp)
    80000dde:	e05a                	sd	s6,0(sp)
    80000de0:	0080                	addi	s0,sp,64
    80000de2:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000de4:	00008497          	auipc	s1,0x8
    80000de8:	ffc48493          	addi	s1,s1,-4 # 80008de0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000dec:	8b26                	mv	s6,s1
    80000dee:	00007a97          	auipc	s5,0x7
    80000df2:	212a8a93          	addi	s5,s5,530 # 80008000 <etext>
    80000df6:	01000937          	lui	s2,0x1000
    80000dfa:	197d                	addi	s2,s2,-1
    80000dfc:	093a                	slli	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dfe:	0000ea17          	auipc	s4,0xe
    80000e02:	be2a0a13          	addi	s4,s4,-1054 # 8000e9e0 <tickslock>
    char *pa = kalloc();
    80000e06:	fffff097          	auipc	ra,0xfffff
    80000e0a:	312080e7          	jalr	786(ra) # 80000118 <kalloc>
    80000e0e:	862a                	mv	a2,a0
    if(pa == 0)
    80000e10:	c129                	beqz	a0,80000e52 <proc_mapstacks+0x84>
    uint64 va = KSTACK((int) (p - proc));
    80000e12:	416485b3          	sub	a1,s1,s6
    80000e16:	8591                	srai	a1,a1,0x4
    80000e18:	000ab783          	ld	a5,0(s5)
    80000e1c:	02f585b3          	mul	a1,a1,a5
    80000e20:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000e24:	4719                	li	a4,6
    80000e26:	6685                	lui	a3,0x1
    80000e28:	40b905b3          	sub	a1,s2,a1
    80000e2c:	854e                	mv	a0,s3
    80000e2e:	fffff097          	auipc	ra,0xfffff
    80000e32:	7be080e7          	jalr	1982(ra) # 800005ec <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e36:	17048493          	addi	s1,s1,368
    80000e3a:	fd4496e3          	bne	s1,s4,80000e06 <proc_mapstacks+0x38>
  }
}
    80000e3e:	70e2                	ld	ra,56(sp)
    80000e40:	7442                	ld	s0,48(sp)
    80000e42:	74a2                	ld	s1,40(sp)
    80000e44:	7902                	ld	s2,32(sp)
    80000e46:	69e2                	ld	s3,24(sp)
    80000e48:	6a42                	ld	s4,16(sp)
    80000e4a:	6aa2                	ld	s5,8(sp)
    80000e4c:	6b02                	ld	s6,0(sp)
    80000e4e:	6121                	addi	sp,sp,64
    80000e50:	8082                	ret
      panic("kalloc");
    80000e52:	00007517          	auipc	a0,0x7
    80000e56:	36650513          	addi	a0,a0,870 # 800081b8 <etext+0x1b8>
    80000e5a:	00005097          	auipc	ra,0x5
    80000e5e:	018080e7          	jalr	24(ra) # 80005e72 <panic>

0000000080000e62 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000e62:	7139                	addi	sp,sp,-64
    80000e64:	fc06                	sd	ra,56(sp)
    80000e66:	f822                	sd	s0,48(sp)
    80000e68:	f426                	sd	s1,40(sp)
    80000e6a:	f04a                	sd	s2,32(sp)
    80000e6c:	ec4e                	sd	s3,24(sp)
    80000e6e:	e852                	sd	s4,16(sp)
    80000e70:	e456                	sd	s5,8(sp)
    80000e72:	e05a                	sd	s6,0(sp)
    80000e74:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000e76:	00007597          	auipc	a1,0x7
    80000e7a:	34a58593          	addi	a1,a1,842 # 800081c0 <etext+0x1c0>
    80000e7e:	00008517          	auipc	a0,0x8
    80000e82:	b3250513          	addi	a0,a0,-1230 # 800089b0 <pid_lock>
    80000e86:	00005097          	auipc	ra,0x5
    80000e8a:	4a6080e7          	jalr	1190(ra) # 8000632c <initlock>
  initlock(&wait_lock, "wait_lock");
    80000e8e:	00007597          	auipc	a1,0x7
    80000e92:	33a58593          	addi	a1,a1,826 # 800081c8 <etext+0x1c8>
    80000e96:	00008517          	auipc	a0,0x8
    80000e9a:	b3250513          	addi	a0,a0,-1230 # 800089c8 <wait_lock>
    80000e9e:	00005097          	auipc	ra,0x5
    80000ea2:	48e080e7          	jalr	1166(ra) # 8000632c <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ea6:	00008497          	auipc	s1,0x8
    80000eaa:	f3a48493          	addi	s1,s1,-198 # 80008de0 <proc>
      initlock(&p->lock, "proc");
    80000eae:	00007b17          	auipc	s6,0x7
    80000eb2:	32ab0b13          	addi	s6,s6,810 # 800081d8 <etext+0x1d8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000eb6:	8aa6                	mv	s5,s1
    80000eb8:	00007a17          	auipc	s4,0x7
    80000ebc:	148a0a13          	addi	s4,s4,328 # 80008000 <etext>
    80000ec0:	01000937          	lui	s2,0x1000
    80000ec4:	197d                	addi	s2,s2,-1
    80000ec6:	093a                	slli	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ec8:	0000e997          	auipc	s3,0xe
    80000ecc:	b1898993          	addi	s3,s3,-1256 # 8000e9e0 <tickslock>
      initlock(&p->lock, "proc");
    80000ed0:	85da                	mv	a1,s6
    80000ed2:	8526                	mv	a0,s1
    80000ed4:	00005097          	auipc	ra,0x5
    80000ed8:	458080e7          	jalr	1112(ra) # 8000632c <initlock>
      p->state = UNUSED;
    80000edc:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000ee0:	415487b3          	sub	a5,s1,s5
    80000ee4:	8791                	srai	a5,a5,0x4
    80000ee6:	000a3703          	ld	a4,0(s4)
    80000eea:	02e787b3          	mul	a5,a5,a4
    80000eee:	00d7979b          	slliw	a5,a5,0xd
    80000ef2:	40f907b3          	sub	a5,s2,a5
    80000ef6:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ef8:	17048493          	addi	s1,s1,368
    80000efc:	fd349ae3          	bne	s1,s3,80000ed0 <procinit+0x6e>
  }
}
    80000f00:	70e2                	ld	ra,56(sp)
    80000f02:	7442                	ld	s0,48(sp)
    80000f04:	74a2                	ld	s1,40(sp)
    80000f06:	7902                	ld	s2,32(sp)
    80000f08:	69e2                	ld	s3,24(sp)
    80000f0a:	6a42                	ld	s4,16(sp)
    80000f0c:	6aa2                	ld	s5,8(sp)
    80000f0e:	6b02                	ld	s6,0(sp)
    80000f10:	6121                	addi	sp,sp,64
    80000f12:	8082                	ret

0000000080000f14 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000f14:	1141                	addi	sp,sp,-16
    80000f16:	e422                	sd	s0,8(sp)
    80000f18:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000f1a:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000f1c:	2501                	sext.w	a0,a0
    80000f1e:	6422                	ld	s0,8(sp)
    80000f20:	0141                	addi	sp,sp,16
    80000f22:	8082                	ret

0000000080000f24 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000f24:	1141                	addi	sp,sp,-16
    80000f26:	e422                	sd	s0,8(sp)
    80000f28:	0800                	addi	s0,sp,16
    80000f2a:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000f2c:	2781                	sext.w	a5,a5
    80000f2e:	079e                	slli	a5,a5,0x7
  return c;
}
    80000f30:	00008517          	auipc	a0,0x8
    80000f34:	ab050513          	addi	a0,a0,-1360 # 800089e0 <cpus>
    80000f38:	953e                	add	a0,a0,a5
    80000f3a:	6422                	ld	s0,8(sp)
    80000f3c:	0141                	addi	sp,sp,16
    80000f3e:	8082                	ret

0000000080000f40 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000f40:	1101                	addi	sp,sp,-32
    80000f42:	ec06                	sd	ra,24(sp)
    80000f44:	e822                	sd	s0,16(sp)
    80000f46:	e426                	sd	s1,8(sp)
    80000f48:	1000                	addi	s0,sp,32
  push_off();
    80000f4a:	00005097          	auipc	ra,0x5
    80000f4e:	426080e7          	jalr	1062(ra) # 80006370 <push_off>
    80000f52:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000f54:	2781                	sext.w	a5,a5
    80000f56:	079e                	slli	a5,a5,0x7
    80000f58:	00008717          	auipc	a4,0x8
    80000f5c:	a5870713          	addi	a4,a4,-1448 # 800089b0 <pid_lock>
    80000f60:	97ba                	add	a5,a5,a4
    80000f62:	7b84                	ld	s1,48(a5)
  pop_off();
    80000f64:	00005097          	auipc	ra,0x5
    80000f68:	4ac080e7          	jalr	1196(ra) # 80006410 <pop_off>
  return p;
}
    80000f6c:	8526                	mv	a0,s1
    80000f6e:	60e2                	ld	ra,24(sp)
    80000f70:	6442                	ld	s0,16(sp)
    80000f72:	64a2                	ld	s1,8(sp)
    80000f74:	6105                	addi	sp,sp,32
    80000f76:	8082                	ret

0000000080000f78 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000f78:	1141                	addi	sp,sp,-16
    80000f7a:	e406                	sd	ra,8(sp)
    80000f7c:	e022                	sd	s0,0(sp)
    80000f7e:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000f80:	00000097          	auipc	ra,0x0
    80000f84:	fc0080e7          	jalr	-64(ra) # 80000f40 <myproc>
    80000f88:	00005097          	auipc	ra,0x5
    80000f8c:	4e8080e7          	jalr	1256(ra) # 80006470 <release>

  if (first) {
    80000f90:	00008797          	auipc	a5,0x8
    80000f94:	9607a783          	lw	a5,-1696(a5) # 800088f0 <first.1683>
    80000f98:	eb89                	bnez	a5,80000faa <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000f9a:	00001097          	auipc	ra,0x1
    80000f9e:	d1e080e7          	jalr	-738(ra) # 80001cb8 <usertrapret>
}
    80000fa2:	60a2                	ld	ra,8(sp)
    80000fa4:	6402                	ld	s0,0(sp)
    80000fa6:	0141                	addi	sp,sp,16
    80000fa8:	8082                	ret
    first = 0;
    80000faa:	00008797          	auipc	a5,0x8
    80000fae:	9407a323          	sw	zero,-1722(a5) # 800088f0 <first.1683>
    fsinit(ROOTDEV);
    80000fb2:	4505                	li	a0,1
    80000fb4:	00002097          	auipc	ra,0x2
    80000fb8:	b3c080e7          	jalr	-1220(ra) # 80002af0 <fsinit>
    80000fbc:	bff9                	j	80000f9a <forkret+0x22>

0000000080000fbe <allocpid>:
{
    80000fbe:	1101                	addi	sp,sp,-32
    80000fc0:	ec06                	sd	ra,24(sp)
    80000fc2:	e822                	sd	s0,16(sp)
    80000fc4:	e426                	sd	s1,8(sp)
    80000fc6:	e04a                	sd	s2,0(sp)
    80000fc8:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000fca:	00008917          	auipc	s2,0x8
    80000fce:	9e690913          	addi	s2,s2,-1562 # 800089b0 <pid_lock>
    80000fd2:	854a                	mv	a0,s2
    80000fd4:	00005097          	auipc	ra,0x5
    80000fd8:	3e8080e7          	jalr	1000(ra) # 800063bc <acquire>
  pid = nextpid;
    80000fdc:	00008797          	auipc	a5,0x8
    80000fe0:	91878793          	addi	a5,a5,-1768 # 800088f4 <nextpid>
    80000fe4:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000fe6:	0014871b          	addiw	a4,s1,1
    80000fea:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000fec:	854a                	mv	a0,s2
    80000fee:	00005097          	auipc	ra,0x5
    80000ff2:	482080e7          	jalr	1154(ra) # 80006470 <release>
}
    80000ff6:	8526                	mv	a0,s1
    80000ff8:	60e2                	ld	ra,24(sp)
    80000ffa:	6442                	ld	s0,16(sp)
    80000ffc:	64a2                	ld	s1,8(sp)
    80000ffe:	6902                	ld	s2,0(sp)
    80001000:	6105                	addi	sp,sp,32
    80001002:	8082                	ret

0000000080001004 <proc_pagetable>:
{
    80001004:	1101                	addi	sp,sp,-32
    80001006:	ec06                	sd	ra,24(sp)
    80001008:	e822                	sd	s0,16(sp)
    8000100a:	e426                	sd	s1,8(sp)
    8000100c:	e04a                	sd	s2,0(sp)
    8000100e:	1000                	addi	s0,sp,32
    80001010:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001012:	fffff097          	auipc	ra,0xfffff
    80001016:	7c4080e7          	jalr	1988(ra) # 800007d6 <uvmcreate>
    8000101a:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000101c:	cd39                	beqz	a0,8000107a <proc_pagetable+0x76>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    8000101e:	4729                	li	a4,10
    80001020:	00006697          	auipc	a3,0x6
    80001024:	fe068693          	addi	a3,a3,-32 # 80007000 <_trampoline>
    80001028:	6605                	lui	a2,0x1
    8000102a:	040005b7          	lui	a1,0x4000
    8000102e:	15fd                	addi	a1,a1,-1
    80001030:	05b2                	slli	a1,a1,0xc
    80001032:	fffff097          	auipc	ra,0xfffff
    80001036:	51a080e7          	jalr	1306(ra) # 8000054c <mappages>
    8000103a:	04054763          	bltz	a0,80001088 <proc_pagetable+0x84>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    8000103e:	4719                	li	a4,6
    80001040:	05893683          	ld	a3,88(s2)
    80001044:	6605                	lui	a2,0x1
    80001046:	020005b7          	lui	a1,0x2000
    8000104a:	15fd                	addi	a1,a1,-1
    8000104c:	05b6                	slli	a1,a1,0xd
    8000104e:	8526                	mv	a0,s1
    80001050:	fffff097          	auipc	ra,0xfffff
    80001054:	4fc080e7          	jalr	1276(ra) # 8000054c <mappages>
    80001058:	04054063          	bltz	a0,80001098 <proc_pagetable+0x94>
  if(mappages(pagetable, USYSCALL, PGSIZE,
    8000105c:	4749                	li	a4,18
    8000105e:	16893683          	ld	a3,360(s2)
    80001062:	6605                	lui	a2,0x1
    80001064:	040005b7          	lui	a1,0x4000
    80001068:	15f5                	addi	a1,a1,-3
    8000106a:	05b2                	slli	a1,a1,0xc
    8000106c:	8526                	mv	a0,s1
    8000106e:	fffff097          	auipc	ra,0xfffff
    80001072:	4de080e7          	jalr	1246(ra) # 8000054c <mappages>
    80001076:	04054463          	bltz	a0,800010be <proc_pagetable+0xba>
}
    8000107a:	8526                	mv	a0,s1
    8000107c:	60e2                	ld	ra,24(sp)
    8000107e:	6442                	ld	s0,16(sp)
    80001080:	64a2                	ld	s1,8(sp)
    80001082:	6902                	ld	s2,0(sp)
    80001084:	6105                	addi	sp,sp,32
    80001086:	8082                	ret
    uvmfree(pagetable, 0);
    80001088:	4581                	li	a1,0
    8000108a:	8526                	mv	a0,s1
    8000108c:	00000097          	auipc	ra,0x0
    80001090:	94e080e7          	jalr	-1714(ra) # 800009da <uvmfree>
    return 0;
    80001094:	4481                	li	s1,0
    80001096:	b7d5                	j	8000107a <proc_pagetable+0x76>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001098:	4681                	li	a3,0
    8000109a:	4605                	li	a2,1
    8000109c:	040005b7          	lui	a1,0x4000
    800010a0:	15fd                	addi	a1,a1,-1
    800010a2:	05b2                	slli	a1,a1,0xc
    800010a4:	8526                	mv	a0,s1
    800010a6:	fffff097          	auipc	ra,0xfffff
    800010aa:	66c080e7          	jalr	1644(ra) # 80000712 <uvmunmap>
    uvmfree(pagetable, 0);
    800010ae:	4581                	li	a1,0
    800010b0:	8526                	mv	a0,s1
    800010b2:	00000097          	auipc	ra,0x0
    800010b6:	928080e7          	jalr	-1752(ra) # 800009da <uvmfree>
    return 0;
    800010ba:	4481                	li	s1,0
    800010bc:	bf7d                	j	8000107a <proc_pagetable+0x76>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800010be:	4681                	li	a3,0
    800010c0:	4605                	li	a2,1
    800010c2:	04000937          	lui	s2,0x4000
    800010c6:	fff90593          	addi	a1,s2,-1 # 3ffffff <_entry-0x7c000001>
    800010ca:	05b2                	slli	a1,a1,0xc
    800010cc:	8526                	mv	a0,s1
    800010ce:	fffff097          	auipc	ra,0xfffff
    800010d2:	644080e7          	jalr	1604(ra) # 80000712 <uvmunmap>
    uvmunmap(pagetable, TRAPFRAME, 1, 0);
    800010d6:	4681                	li	a3,0
    800010d8:	4605                	li	a2,1
    800010da:	020005b7          	lui	a1,0x2000
    800010de:	15fd                	addi	a1,a1,-1
    800010e0:	05b6                	slli	a1,a1,0xd
    800010e2:	8526                	mv	a0,s1
    800010e4:	fffff097          	auipc	ra,0xfffff
    800010e8:	62e080e7          	jalr	1582(ra) # 80000712 <uvmunmap>
    uvmunmap(pagetable, USYSCALL, 1, 0);
    800010ec:	4681                	li	a3,0
    800010ee:	4605                	li	a2,1
    800010f0:	ffd90593          	addi	a1,s2,-3
    800010f4:	05b2                	slli	a1,a1,0xc
    800010f6:	8526                	mv	a0,s1
    800010f8:	fffff097          	auipc	ra,0xfffff
    800010fc:	61a080e7          	jalr	1562(ra) # 80000712 <uvmunmap>
    uvmfree(pagetable, 0);
    80001100:	4581                	li	a1,0
    80001102:	8526                	mv	a0,s1
    80001104:	00000097          	auipc	ra,0x0
    80001108:	8d6080e7          	jalr	-1834(ra) # 800009da <uvmfree>
    return 0;
    8000110c:	4481                	li	s1,0
    8000110e:	b7b5                	j	8000107a <proc_pagetable+0x76>

0000000080001110 <proc_freepagetable>:
{
    80001110:	7179                	addi	sp,sp,-48
    80001112:	f406                	sd	ra,40(sp)
    80001114:	f022                	sd	s0,32(sp)
    80001116:	ec26                	sd	s1,24(sp)
    80001118:	e84a                	sd	s2,16(sp)
    8000111a:	e44e                	sd	s3,8(sp)
    8000111c:	1800                	addi	s0,sp,48
    8000111e:	84aa                	mv	s1,a0
    80001120:	89ae                	mv	s3,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001122:	4681                	li	a3,0
    80001124:	4605                	li	a2,1
    80001126:	04000937          	lui	s2,0x4000
    8000112a:	fff90593          	addi	a1,s2,-1 # 3ffffff <_entry-0x7c000001>
    8000112e:	05b2                	slli	a1,a1,0xc
    80001130:	fffff097          	auipc	ra,0xfffff
    80001134:	5e2080e7          	jalr	1506(ra) # 80000712 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001138:	4681                	li	a3,0
    8000113a:	4605                	li	a2,1
    8000113c:	020005b7          	lui	a1,0x2000
    80001140:	15fd                	addi	a1,a1,-1
    80001142:	05b6                	slli	a1,a1,0xd
    80001144:	8526                	mv	a0,s1
    80001146:	fffff097          	auipc	ra,0xfffff
    8000114a:	5cc080e7          	jalr	1484(ra) # 80000712 <uvmunmap>
  uvmunmap(pagetable, USYSCALL, 1, 0);
    8000114e:	4681                	li	a3,0
    80001150:	4605                	li	a2,1
    80001152:	1975                	addi	s2,s2,-3
    80001154:	00c91593          	slli	a1,s2,0xc
    80001158:	8526                	mv	a0,s1
    8000115a:	fffff097          	auipc	ra,0xfffff
    8000115e:	5b8080e7          	jalr	1464(ra) # 80000712 <uvmunmap>
  uvmfree(pagetable, sz);
    80001162:	85ce                	mv	a1,s3
    80001164:	8526                	mv	a0,s1
    80001166:	00000097          	auipc	ra,0x0
    8000116a:	874080e7          	jalr	-1932(ra) # 800009da <uvmfree>
}
    8000116e:	70a2                	ld	ra,40(sp)
    80001170:	7402                	ld	s0,32(sp)
    80001172:	64e2                	ld	s1,24(sp)
    80001174:	6942                	ld	s2,16(sp)
    80001176:	69a2                	ld	s3,8(sp)
    80001178:	6145                	addi	sp,sp,48
    8000117a:	8082                	ret

000000008000117c <freeproc>:
{
    8000117c:	1101                	addi	sp,sp,-32
    8000117e:	ec06                	sd	ra,24(sp)
    80001180:	e822                	sd	s0,16(sp)
    80001182:	e426                	sd	s1,8(sp)
    80001184:	1000                	addi	s0,sp,32
    80001186:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001188:	6d28                	ld	a0,88(a0)
    8000118a:	c509                	beqz	a0,80001194 <freeproc+0x18>
    kfree((void*)p->trapframe);
    8000118c:	fffff097          	auipc	ra,0xfffff
    80001190:	e90080e7          	jalr	-368(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001194:	0404bc23          	sd	zero,88(s1)
  if(p->store_pid){
    80001198:	1684b503          	ld	a0,360(s1)
    8000119c:	c509                	beqz	a0,800011a6 <freeproc+0x2a>
   kfree((void*)p->store_pid);
    8000119e:	fffff097          	auipc	ra,0xfffff
    800011a2:	e7e080e7          	jalr	-386(ra) # 8000001c <kfree>
  p->store_pid = 0;
    800011a6:	1604b423          	sd	zero,360(s1)
  if(p->pagetable)
    800011aa:	68a8                	ld	a0,80(s1)
    800011ac:	c511                	beqz	a0,800011b8 <freeproc+0x3c>
    proc_freepagetable(p->pagetable, p->sz);
    800011ae:	64ac                	ld	a1,72(s1)
    800011b0:	00000097          	auipc	ra,0x0
    800011b4:	f60080e7          	jalr	-160(ra) # 80001110 <proc_freepagetable>
  p->pagetable = 0;
    800011b8:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    800011bc:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    800011c0:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    800011c4:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    800011c8:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    800011cc:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    800011d0:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    800011d4:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    800011d8:	0004ac23          	sw	zero,24(s1)
}
    800011dc:	60e2                	ld	ra,24(sp)
    800011de:	6442                	ld	s0,16(sp)
    800011e0:	64a2                	ld	s1,8(sp)
    800011e2:	6105                	addi	sp,sp,32
    800011e4:	8082                	ret

00000000800011e6 <allocproc>:
{
    800011e6:	1101                	addi	sp,sp,-32
    800011e8:	ec06                	sd	ra,24(sp)
    800011ea:	e822                	sd	s0,16(sp)
    800011ec:	e426                	sd	s1,8(sp)
    800011ee:	e04a                	sd	s2,0(sp)
    800011f0:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800011f2:	00008497          	auipc	s1,0x8
    800011f6:	bee48493          	addi	s1,s1,-1042 # 80008de0 <proc>
    800011fa:	0000d917          	auipc	s2,0xd
    800011fe:	7e690913          	addi	s2,s2,2022 # 8000e9e0 <tickslock>
    acquire(&p->lock);
    80001202:	8526                	mv	a0,s1
    80001204:	00005097          	auipc	ra,0x5
    80001208:	1b8080e7          	jalr	440(ra) # 800063bc <acquire>
    if(p->state == UNUSED) {
    8000120c:	4c9c                	lw	a5,24(s1)
    8000120e:	cf81                	beqz	a5,80001226 <allocproc+0x40>
      release(&p->lock);
    80001210:	8526                	mv	a0,s1
    80001212:	00005097          	auipc	ra,0x5
    80001216:	25e080e7          	jalr	606(ra) # 80006470 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000121a:	17048493          	addi	s1,s1,368
    8000121e:	ff2492e3          	bne	s1,s2,80001202 <allocproc+0x1c>
  return 0;
    80001222:	4481                	li	s1,0
    80001224:	a09d                	j	8000128a <allocproc+0xa4>
  p->pid = allocpid();
    80001226:	00000097          	auipc	ra,0x0
    8000122a:	d98080e7          	jalr	-616(ra) # 80000fbe <allocpid>
    8000122e:	d888                	sw	a0,48(s1)
  p->state = USED; 
    80001230:	4785                	li	a5,1
    80001232:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001234:	fffff097          	auipc	ra,0xfffff
    80001238:	ee4080e7          	jalr	-284(ra) # 80000118 <kalloc>
    8000123c:	892a                	mv	s2,a0
    8000123e:	eca8                	sd	a0,88(s1)
    80001240:	cd21                	beqz	a0,80001298 <allocproc+0xb2>
  if((p->store_pid = (struct usyscall*)kalloc()) == 0){
    80001242:	fffff097          	auipc	ra,0xfffff
    80001246:	ed6080e7          	jalr	-298(ra) # 80000118 <kalloc>
    8000124a:	892a                	mv	s2,a0
    8000124c:	16a4b423          	sd	a0,360(s1)
    80001250:	c125                	beqz	a0,800012b0 <allocproc+0xca>
  (p->store_pid)->pid = p->pid;
    80001252:	589c                	lw	a5,48(s1)
    80001254:	c11c                	sw	a5,0(a0)
  p->pagetable = proc_pagetable(p);
    80001256:	8526                	mv	a0,s1
    80001258:	00000097          	auipc	ra,0x0
    8000125c:	dac080e7          	jalr	-596(ra) # 80001004 <proc_pagetable>
    80001260:	892a                	mv	s2,a0
    80001262:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001264:	c135                	beqz	a0,800012c8 <allocproc+0xe2>
  memset(&p->context, 0, sizeof(p->context));
    80001266:	07000613          	li	a2,112
    8000126a:	4581                	li	a1,0
    8000126c:	06048513          	addi	a0,s1,96
    80001270:	fffff097          	auipc	ra,0xfffff
    80001274:	f08080e7          	jalr	-248(ra) # 80000178 <memset>
  p->context.ra = (uint64)forkret;
    80001278:	00000797          	auipc	a5,0x0
    8000127c:	d0078793          	addi	a5,a5,-768 # 80000f78 <forkret>
    80001280:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001282:	60bc                	ld	a5,64(s1)
    80001284:	6705                	lui	a4,0x1
    80001286:	97ba                	add	a5,a5,a4
    80001288:	f4bc                	sd	a5,104(s1)
}
    8000128a:	8526                	mv	a0,s1
    8000128c:	60e2                	ld	ra,24(sp)
    8000128e:	6442                	ld	s0,16(sp)
    80001290:	64a2                	ld	s1,8(sp)
    80001292:	6902                	ld	s2,0(sp)
    80001294:	6105                	addi	sp,sp,32
    80001296:	8082                	ret
    freeproc(p);
    80001298:	8526                	mv	a0,s1
    8000129a:	00000097          	auipc	ra,0x0
    8000129e:	ee2080e7          	jalr	-286(ra) # 8000117c <freeproc>
    release(&p->lock);
    800012a2:	8526                	mv	a0,s1
    800012a4:	00005097          	auipc	ra,0x5
    800012a8:	1cc080e7          	jalr	460(ra) # 80006470 <release>
    return 0;
    800012ac:	84ca                	mv	s1,s2
    800012ae:	bff1                	j	8000128a <allocproc+0xa4>
    freeproc(p);
    800012b0:	8526                	mv	a0,s1
    800012b2:	00000097          	auipc	ra,0x0
    800012b6:	eca080e7          	jalr	-310(ra) # 8000117c <freeproc>
    release(&p->lock);
    800012ba:	8526                	mv	a0,s1
    800012bc:	00005097          	auipc	ra,0x5
    800012c0:	1b4080e7          	jalr	436(ra) # 80006470 <release>
    return 0;
    800012c4:	84ca                	mv	s1,s2
    800012c6:	b7d1                	j	8000128a <allocproc+0xa4>
    freeproc(p);
    800012c8:	8526                	mv	a0,s1
    800012ca:	00000097          	auipc	ra,0x0
    800012ce:	eb2080e7          	jalr	-334(ra) # 8000117c <freeproc>
    release(&p->lock);
    800012d2:	8526                	mv	a0,s1
    800012d4:	00005097          	auipc	ra,0x5
    800012d8:	19c080e7          	jalr	412(ra) # 80006470 <release>
    return 0;
    800012dc:	84ca                	mv	s1,s2
    800012de:	b775                	j	8000128a <allocproc+0xa4>

00000000800012e0 <userinit>:
{
    800012e0:	1101                	addi	sp,sp,-32
    800012e2:	ec06                	sd	ra,24(sp)
    800012e4:	e822                	sd	s0,16(sp)
    800012e6:	e426                	sd	s1,8(sp)
    800012e8:	1000                	addi	s0,sp,32
  p = allocproc();
    800012ea:	00000097          	auipc	ra,0x0
    800012ee:	efc080e7          	jalr	-260(ra) # 800011e6 <allocproc>
    800012f2:	84aa                	mv	s1,a0
  initproc = p;
    800012f4:	00007797          	auipc	a5,0x7
    800012f8:	66a7be23          	sd	a0,1660(a5) # 80008970 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    800012fc:	03400613          	li	a2,52
    80001300:	00007597          	auipc	a1,0x7
    80001304:	60058593          	addi	a1,a1,1536 # 80008900 <initcode>
    80001308:	6928                	ld	a0,80(a0)
    8000130a:	fffff097          	auipc	ra,0xfffff
    8000130e:	4fa080e7          	jalr	1274(ra) # 80000804 <uvmfirst>
  p->sz = PGSIZE;
    80001312:	6785                	lui	a5,0x1
    80001314:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001316:	6cb8                	ld	a4,88(s1)
    80001318:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    8000131c:	6cb8                	ld	a4,88(s1)
    8000131e:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001320:	4641                	li	a2,16
    80001322:	00007597          	auipc	a1,0x7
    80001326:	ebe58593          	addi	a1,a1,-322 # 800081e0 <etext+0x1e0>
    8000132a:	15848513          	addi	a0,s1,344
    8000132e:	fffff097          	auipc	ra,0xfffff
    80001332:	f9c080e7          	jalr	-100(ra) # 800002ca <safestrcpy>
  p->cwd = namei("/");
    80001336:	00007517          	auipc	a0,0x7
    8000133a:	eba50513          	addi	a0,a0,-326 # 800081f0 <etext+0x1f0>
    8000133e:	00002097          	auipc	ra,0x2
    80001342:	1d4080e7          	jalr	468(ra) # 80003512 <namei>
    80001346:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000134a:	478d                	li	a5,3
    8000134c:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000134e:	8526                	mv	a0,s1
    80001350:	00005097          	auipc	ra,0x5
    80001354:	120080e7          	jalr	288(ra) # 80006470 <release>
}
    80001358:	60e2                	ld	ra,24(sp)
    8000135a:	6442                	ld	s0,16(sp)
    8000135c:	64a2                	ld	s1,8(sp)
    8000135e:	6105                	addi	sp,sp,32
    80001360:	8082                	ret

0000000080001362 <growproc>:
{
    80001362:	1101                	addi	sp,sp,-32
    80001364:	ec06                	sd	ra,24(sp)
    80001366:	e822                	sd	s0,16(sp)
    80001368:	e426                	sd	s1,8(sp)
    8000136a:	e04a                	sd	s2,0(sp)
    8000136c:	1000                	addi	s0,sp,32
    8000136e:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001370:	00000097          	auipc	ra,0x0
    80001374:	bd0080e7          	jalr	-1072(ra) # 80000f40 <myproc>
    80001378:	84aa                	mv	s1,a0
  sz = p->sz;
    8000137a:	652c                	ld	a1,72(a0)
  if(n > 0){
    8000137c:	01204c63          	bgtz	s2,80001394 <growproc+0x32>
  } else if(n < 0){
    80001380:	02094663          	bltz	s2,800013ac <growproc+0x4a>
  p->sz = sz;
    80001384:	e4ac                	sd	a1,72(s1)
  return 0;
    80001386:	4501                	li	a0,0
}
    80001388:	60e2                	ld	ra,24(sp)
    8000138a:	6442                	ld	s0,16(sp)
    8000138c:	64a2                	ld	s1,8(sp)
    8000138e:	6902                	ld	s2,0(sp)
    80001390:	6105                	addi	sp,sp,32
    80001392:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001394:	4691                	li	a3,4
    80001396:	00b90633          	add	a2,s2,a1
    8000139a:	6928                	ld	a0,80(a0)
    8000139c:	fffff097          	auipc	ra,0xfffff
    800013a0:	522080e7          	jalr	1314(ra) # 800008be <uvmalloc>
    800013a4:	85aa                	mv	a1,a0
    800013a6:	fd79                	bnez	a0,80001384 <growproc+0x22>
      return -1;
    800013a8:	557d                	li	a0,-1
    800013aa:	bff9                	j	80001388 <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800013ac:	00b90633          	add	a2,s2,a1
    800013b0:	6928                	ld	a0,80(a0)
    800013b2:	fffff097          	auipc	ra,0xfffff
    800013b6:	4c4080e7          	jalr	1220(ra) # 80000876 <uvmdealloc>
    800013ba:	85aa                	mv	a1,a0
    800013bc:	b7e1                	j	80001384 <growproc+0x22>

00000000800013be <fork>:
{
    800013be:	7179                	addi	sp,sp,-48
    800013c0:	f406                	sd	ra,40(sp)
    800013c2:	f022                	sd	s0,32(sp)
    800013c4:	ec26                	sd	s1,24(sp)
    800013c6:	e84a                	sd	s2,16(sp)
    800013c8:	e44e                	sd	s3,8(sp)
    800013ca:	e052                	sd	s4,0(sp)
    800013cc:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800013ce:	00000097          	auipc	ra,0x0
    800013d2:	b72080e7          	jalr	-1166(ra) # 80000f40 <myproc>
    800013d6:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    800013d8:	00000097          	auipc	ra,0x0
    800013dc:	e0e080e7          	jalr	-498(ra) # 800011e6 <allocproc>
    800013e0:	10050b63          	beqz	a0,800014f6 <fork+0x138>
    800013e4:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800013e6:	04893603          	ld	a2,72(s2)
    800013ea:	692c                	ld	a1,80(a0)
    800013ec:	05093503          	ld	a0,80(s2)
    800013f0:	fffff097          	auipc	ra,0xfffff
    800013f4:	622080e7          	jalr	1570(ra) # 80000a12 <uvmcopy>
    800013f8:	04054663          	bltz	a0,80001444 <fork+0x86>
  np->sz = p->sz;
    800013fc:	04893783          	ld	a5,72(s2)
    80001400:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    80001404:	05893683          	ld	a3,88(s2)
    80001408:	87b6                	mv	a5,a3
    8000140a:	0589b703          	ld	a4,88(s3)
    8000140e:	12068693          	addi	a3,a3,288
    80001412:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001416:	6788                	ld	a0,8(a5)
    80001418:	6b8c                	ld	a1,16(a5)
    8000141a:	6f90                	ld	a2,24(a5)
    8000141c:	01073023          	sd	a6,0(a4)
    80001420:	e708                	sd	a0,8(a4)
    80001422:	eb0c                	sd	a1,16(a4)
    80001424:	ef10                	sd	a2,24(a4)
    80001426:	02078793          	addi	a5,a5,32
    8000142a:	02070713          	addi	a4,a4,32
    8000142e:	fed792e3          	bne	a5,a3,80001412 <fork+0x54>
  np->trapframe->a0 = 0;
    80001432:	0589b783          	ld	a5,88(s3)
    80001436:	0607b823          	sd	zero,112(a5)
    8000143a:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    8000143e:	15000a13          	li	s4,336
    80001442:	a03d                	j	80001470 <fork+0xb2>
    freeproc(np);
    80001444:	854e                	mv	a0,s3
    80001446:	00000097          	auipc	ra,0x0
    8000144a:	d36080e7          	jalr	-714(ra) # 8000117c <freeproc>
    release(&np->lock);
    8000144e:	854e                	mv	a0,s3
    80001450:	00005097          	auipc	ra,0x5
    80001454:	020080e7          	jalr	32(ra) # 80006470 <release>
    return -1;
    80001458:	5a7d                	li	s4,-1
    8000145a:	a069                	j	800014e4 <fork+0x126>
      np->ofile[i] = filedup(p->ofile[i]);
    8000145c:	00002097          	auipc	ra,0x2
    80001460:	74c080e7          	jalr	1868(ra) # 80003ba8 <filedup>
    80001464:	009987b3          	add	a5,s3,s1
    80001468:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    8000146a:	04a1                	addi	s1,s1,8
    8000146c:	01448763          	beq	s1,s4,8000147a <fork+0xbc>
    if(p->ofile[i])
    80001470:	009907b3          	add	a5,s2,s1
    80001474:	6388                	ld	a0,0(a5)
    80001476:	f17d                	bnez	a0,8000145c <fork+0x9e>
    80001478:	bfcd                	j	8000146a <fork+0xac>
  np->cwd = idup(p->cwd);
    8000147a:	15093503          	ld	a0,336(s2)
    8000147e:	00002097          	auipc	ra,0x2
    80001482:	8b0080e7          	jalr	-1872(ra) # 80002d2e <idup>
    80001486:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000148a:	4641                	li	a2,16
    8000148c:	15890593          	addi	a1,s2,344
    80001490:	15898513          	addi	a0,s3,344
    80001494:	fffff097          	auipc	ra,0xfffff
    80001498:	e36080e7          	jalr	-458(ra) # 800002ca <safestrcpy>
  pid = np->pid;
    8000149c:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    800014a0:	854e                	mv	a0,s3
    800014a2:	00005097          	auipc	ra,0x5
    800014a6:	fce080e7          	jalr	-50(ra) # 80006470 <release>
  acquire(&wait_lock);
    800014aa:	00007497          	auipc	s1,0x7
    800014ae:	51e48493          	addi	s1,s1,1310 # 800089c8 <wait_lock>
    800014b2:	8526                	mv	a0,s1
    800014b4:	00005097          	auipc	ra,0x5
    800014b8:	f08080e7          	jalr	-248(ra) # 800063bc <acquire>
  np->parent = p;
    800014bc:	0329bc23          	sd	s2,56(s3)
  release(&wait_lock);
    800014c0:	8526                	mv	a0,s1
    800014c2:	00005097          	auipc	ra,0x5
    800014c6:	fae080e7          	jalr	-82(ra) # 80006470 <release>
  acquire(&np->lock);
    800014ca:	854e                	mv	a0,s3
    800014cc:	00005097          	auipc	ra,0x5
    800014d0:	ef0080e7          	jalr	-272(ra) # 800063bc <acquire>
  np->state = RUNNABLE;
    800014d4:	478d                	li	a5,3
    800014d6:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    800014da:	854e                	mv	a0,s3
    800014dc:	00005097          	auipc	ra,0x5
    800014e0:	f94080e7          	jalr	-108(ra) # 80006470 <release>
}
    800014e4:	8552                	mv	a0,s4
    800014e6:	70a2                	ld	ra,40(sp)
    800014e8:	7402                	ld	s0,32(sp)
    800014ea:	64e2                	ld	s1,24(sp)
    800014ec:	6942                	ld	s2,16(sp)
    800014ee:	69a2                	ld	s3,8(sp)
    800014f0:	6a02                	ld	s4,0(sp)
    800014f2:	6145                	addi	sp,sp,48
    800014f4:	8082                	ret
    return -1;
    800014f6:	5a7d                	li	s4,-1
    800014f8:	b7f5                	j	800014e4 <fork+0x126>

00000000800014fa <scheduler>:
{
    800014fa:	7139                	addi	sp,sp,-64
    800014fc:	fc06                	sd	ra,56(sp)
    800014fe:	f822                	sd	s0,48(sp)
    80001500:	f426                	sd	s1,40(sp)
    80001502:	f04a                	sd	s2,32(sp)
    80001504:	ec4e                	sd	s3,24(sp)
    80001506:	e852                	sd	s4,16(sp)
    80001508:	e456                	sd	s5,8(sp)
    8000150a:	e05a                	sd	s6,0(sp)
    8000150c:	0080                	addi	s0,sp,64
    8000150e:	8792                	mv	a5,tp
  int id = r_tp();
    80001510:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001512:	00779a93          	slli	s5,a5,0x7
    80001516:	00007717          	auipc	a4,0x7
    8000151a:	49a70713          	addi	a4,a4,1178 # 800089b0 <pid_lock>
    8000151e:	9756                	add	a4,a4,s5
    80001520:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001524:	00007717          	auipc	a4,0x7
    80001528:	4c470713          	addi	a4,a4,1220 # 800089e8 <cpus+0x8>
    8000152c:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    8000152e:	498d                	li	s3,3
        p->state = RUNNING;
    80001530:	4b11                	li	s6,4
        c->proc = p;
    80001532:	079e                	slli	a5,a5,0x7
    80001534:	00007a17          	auipc	s4,0x7
    80001538:	47ca0a13          	addi	s4,s4,1148 # 800089b0 <pid_lock>
    8000153c:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    8000153e:	0000d917          	auipc	s2,0xd
    80001542:	4a290913          	addi	s2,s2,1186 # 8000e9e0 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001546:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000154a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000154e:	10079073          	csrw	sstatus,a5
    80001552:	00008497          	auipc	s1,0x8
    80001556:	88e48493          	addi	s1,s1,-1906 # 80008de0 <proc>
    8000155a:	a03d                	j	80001588 <scheduler+0x8e>
        p->state = RUNNING;
    8000155c:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001560:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001564:	06048593          	addi	a1,s1,96
    80001568:	8556                	mv	a0,s5
    8000156a:	00000097          	auipc	ra,0x0
    8000156e:	6a4080e7          	jalr	1700(ra) # 80001c0e <swtch>
        c->proc = 0;
    80001572:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    80001576:	8526                	mv	a0,s1
    80001578:	00005097          	auipc	ra,0x5
    8000157c:	ef8080e7          	jalr	-264(ra) # 80006470 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001580:	17048493          	addi	s1,s1,368
    80001584:	fd2481e3          	beq	s1,s2,80001546 <scheduler+0x4c>
      acquire(&p->lock);
    80001588:	8526                	mv	a0,s1
    8000158a:	00005097          	auipc	ra,0x5
    8000158e:	e32080e7          	jalr	-462(ra) # 800063bc <acquire>
      if(p->state == RUNNABLE) {
    80001592:	4c9c                	lw	a5,24(s1)
    80001594:	ff3791e3          	bne	a5,s3,80001576 <scheduler+0x7c>
    80001598:	b7d1                	j	8000155c <scheduler+0x62>

000000008000159a <sched>:
{
    8000159a:	7179                	addi	sp,sp,-48
    8000159c:	f406                	sd	ra,40(sp)
    8000159e:	f022                	sd	s0,32(sp)
    800015a0:	ec26                	sd	s1,24(sp)
    800015a2:	e84a                	sd	s2,16(sp)
    800015a4:	e44e                	sd	s3,8(sp)
    800015a6:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800015a8:	00000097          	auipc	ra,0x0
    800015ac:	998080e7          	jalr	-1640(ra) # 80000f40 <myproc>
    800015b0:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800015b2:	00005097          	auipc	ra,0x5
    800015b6:	d90080e7          	jalr	-624(ra) # 80006342 <holding>
    800015ba:	c93d                	beqz	a0,80001630 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    800015bc:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800015be:	2781                	sext.w	a5,a5
    800015c0:	079e                	slli	a5,a5,0x7
    800015c2:	00007717          	auipc	a4,0x7
    800015c6:	3ee70713          	addi	a4,a4,1006 # 800089b0 <pid_lock>
    800015ca:	97ba                	add	a5,a5,a4
    800015cc:	0a87a703          	lw	a4,168(a5)
    800015d0:	4785                	li	a5,1
    800015d2:	06f71763          	bne	a4,a5,80001640 <sched+0xa6>
  if(p->state == RUNNING)
    800015d6:	4c98                	lw	a4,24(s1)
    800015d8:	4791                	li	a5,4
    800015da:	06f70b63          	beq	a4,a5,80001650 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800015de:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800015e2:	8b89                	andi	a5,a5,2
  if(intr_get())
    800015e4:	efb5                	bnez	a5,80001660 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800015e6:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800015e8:	00007917          	auipc	s2,0x7
    800015ec:	3c890913          	addi	s2,s2,968 # 800089b0 <pid_lock>
    800015f0:	2781                	sext.w	a5,a5
    800015f2:	079e                	slli	a5,a5,0x7
    800015f4:	97ca                	add	a5,a5,s2
    800015f6:	0ac7a983          	lw	s3,172(a5)
    800015fa:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800015fc:	2781                	sext.w	a5,a5
    800015fe:	079e                	slli	a5,a5,0x7
    80001600:	00007597          	auipc	a1,0x7
    80001604:	3e858593          	addi	a1,a1,1000 # 800089e8 <cpus+0x8>
    80001608:	95be                	add	a1,a1,a5
    8000160a:	06048513          	addi	a0,s1,96
    8000160e:	00000097          	auipc	ra,0x0
    80001612:	600080e7          	jalr	1536(ra) # 80001c0e <swtch>
    80001616:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001618:	2781                	sext.w	a5,a5
    8000161a:	079e                	slli	a5,a5,0x7
    8000161c:	97ca                	add	a5,a5,s2
    8000161e:	0b37a623          	sw	s3,172(a5)
}
    80001622:	70a2                	ld	ra,40(sp)
    80001624:	7402                	ld	s0,32(sp)
    80001626:	64e2                	ld	s1,24(sp)
    80001628:	6942                	ld	s2,16(sp)
    8000162a:	69a2                	ld	s3,8(sp)
    8000162c:	6145                	addi	sp,sp,48
    8000162e:	8082                	ret
    panic("sched p->lock");
    80001630:	00007517          	auipc	a0,0x7
    80001634:	bc850513          	addi	a0,a0,-1080 # 800081f8 <etext+0x1f8>
    80001638:	00005097          	auipc	ra,0x5
    8000163c:	83a080e7          	jalr	-1990(ra) # 80005e72 <panic>
    panic("sched locks");
    80001640:	00007517          	auipc	a0,0x7
    80001644:	bc850513          	addi	a0,a0,-1080 # 80008208 <etext+0x208>
    80001648:	00005097          	auipc	ra,0x5
    8000164c:	82a080e7          	jalr	-2006(ra) # 80005e72 <panic>
    panic("sched running");
    80001650:	00007517          	auipc	a0,0x7
    80001654:	bc850513          	addi	a0,a0,-1080 # 80008218 <etext+0x218>
    80001658:	00005097          	auipc	ra,0x5
    8000165c:	81a080e7          	jalr	-2022(ra) # 80005e72 <panic>
    panic("sched interruptible");
    80001660:	00007517          	auipc	a0,0x7
    80001664:	bc850513          	addi	a0,a0,-1080 # 80008228 <etext+0x228>
    80001668:	00005097          	auipc	ra,0x5
    8000166c:	80a080e7          	jalr	-2038(ra) # 80005e72 <panic>

0000000080001670 <yield>:
{
    80001670:	1101                	addi	sp,sp,-32
    80001672:	ec06                	sd	ra,24(sp)
    80001674:	e822                	sd	s0,16(sp)
    80001676:	e426                	sd	s1,8(sp)
    80001678:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000167a:	00000097          	auipc	ra,0x0
    8000167e:	8c6080e7          	jalr	-1850(ra) # 80000f40 <myproc>
    80001682:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001684:	00005097          	auipc	ra,0x5
    80001688:	d38080e7          	jalr	-712(ra) # 800063bc <acquire>
  p->state = RUNNABLE;
    8000168c:	478d                	li	a5,3
    8000168e:	cc9c                	sw	a5,24(s1)
  sched();
    80001690:	00000097          	auipc	ra,0x0
    80001694:	f0a080e7          	jalr	-246(ra) # 8000159a <sched>
  release(&p->lock);
    80001698:	8526                	mv	a0,s1
    8000169a:	00005097          	auipc	ra,0x5
    8000169e:	dd6080e7          	jalr	-554(ra) # 80006470 <release>
}
    800016a2:	60e2                	ld	ra,24(sp)
    800016a4:	6442                	ld	s0,16(sp)
    800016a6:	64a2                	ld	s1,8(sp)
    800016a8:	6105                	addi	sp,sp,32
    800016aa:	8082                	ret

00000000800016ac <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    800016ac:	7179                	addi	sp,sp,-48
    800016ae:	f406                	sd	ra,40(sp)
    800016b0:	f022                	sd	s0,32(sp)
    800016b2:	ec26                	sd	s1,24(sp)
    800016b4:	e84a                	sd	s2,16(sp)
    800016b6:	e44e                	sd	s3,8(sp)
    800016b8:	1800                	addi	s0,sp,48
    800016ba:	89aa                	mv	s3,a0
    800016bc:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800016be:	00000097          	auipc	ra,0x0
    800016c2:	882080e7          	jalr	-1918(ra) # 80000f40 <myproc>
    800016c6:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800016c8:	00005097          	auipc	ra,0x5
    800016cc:	cf4080e7          	jalr	-780(ra) # 800063bc <acquire>
  release(lk);
    800016d0:	854a                	mv	a0,s2
    800016d2:	00005097          	auipc	ra,0x5
    800016d6:	d9e080e7          	jalr	-610(ra) # 80006470 <release>

  // Go to sleep.
  p->chan = chan;
    800016da:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800016de:	4789                	li	a5,2
    800016e0:	cc9c                	sw	a5,24(s1)

  sched();
    800016e2:	00000097          	auipc	ra,0x0
    800016e6:	eb8080e7          	jalr	-328(ra) # 8000159a <sched>

  // Tidy up.
  p->chan = 0;
    800016ea:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800016ee:	8526                	mv	a0,s1
    800016f0:	00005097          	auipc	ra,0x5
    800016f4:	d80080e7          	jalr	-640(ra) # 80006470 <release>
  acquire(lk);
    800016f8:	854a                	mv	a0,s2
    800016fa:	00005097          	auipc	ra,0x5
    800016fe:	cc2080e7          	jalr	-830(ra) # 800063bc <acquire>
}
    80001702:	70a2                	ld	ra,40(sp)
    80001704:	7402                	ld	s0,32(sp)
    80001706:	64e2                	ld	s1,24(sp)
    80001708:	6942                	ld	s2,16(sp)
    8000170a:	69a2                	ld	s3,8(sp)
    8000170c:	6145                	addi	sp,sp,48
    8000170e:	8082                	ret

0000000080001710 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001710:	7139                	addi	sp,sp,-64
    80001712:	fc06                	sd	ra,56(sp)
    80001714:	f822                	sd	s0,48(sp)
    80001716:	f426                	sd	s1,40(sp)
    80001718:	f04a                	sd	s2,32(sp)
    8000171a:	ec4e                	sd	s3,24(sp)
    8000171c:	e852                	sd	s4,16(sp)
    8000171e:	e456                	sd	s5,8(sp)
    80001720:	0080                	addi	s0,sp,64
    80001722:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001724:	00007497          	auipc	s1,0x7
    80001728:	6bc48493          	addi	s1,s1,1724 # 80008de0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    8000172c:	4989                	li	s3,2
        p->state = RUNNABLE;
    8000172e:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001730:	0000d917          	auipc	s2,0xd
    80001734:	2b090913          	addi	s2,s2,688 # 8000e9e0 <tickslock>
    80001738:	a821                	j	80001750 <wakeup+0x40>
        p->state = RUNNABLE;
    8000173a:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    8000173e:	8526                	mv	a0,s1
    80001740:	00005097          	auipc	ra,0x5
    80001744:	d30080e7          	jalr	-720(ra) # 80006470 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001748:	17048493          	addi	s1,s1,368
    8000174c:	03248463          	beq	s1,s2,80001774 <wakeup+0x64>
    if(p != myproc()){
    80001750:	fffff097          	auipc	ra,0xfffff
    80001754:	7f0080e7          	jalr	2032(ra) # 80000f40 <myproc>
    80001758:	fea488e3          	beq	s1,a0,80001748 <wakeup+0x38>
      acquire(&p->lock);
    8000175c:	8526                	mv	a0,s1
    8000175e:	00005097          	auipc	ra,0x5
    80001762:	c5e080e7          	jalr	-930(ra) # 800063bc <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001766:	4c9c                	lw	a5,24(s1)
    80001768:	fd379be3          	bne	a5,s3,8000173e <wakeup+0x2e>
    8000176c:	709c                	ld	a5,32(s1)
    8000176e:	fd4798e3          	bne	a5,s4,8000173e <wakeup+0x2e>
    80001772:	b7e1                	j	8000173a <wakeup+0x2a>
    }
  }
}
    80001774:	70e2                	ld	ra,56(sp)
    80001776:	7442                	ld	s0,48(sp)
    80001778:	74a2                	ld	s1,40(sp)
    8000177a:	7902                	ld	s2,32(sp)
    8000177c:	69e2                	ld	s3,24(sp)
    8000177e:	6a42                	ld	s4,16(sp)
    80001780:	6aa2                	ld	s5,8(sp)
    80001782:	6121                	addi	sp,sp,64
    80001784:	8082                	ret

0000000080001786 <reparent>:
{
    80001786:	7179                	addi	sp,sp,-48
    80001788:	f406                	sd	ra,40(sp)
    8000178a:	f022                	sd	s0,32(sp)
    8000178c:	ec26                	sd	s1,24(sp)
    8000178e:	e84a                	sd	s2,16(sp)
    80001790:	e44e                	sd	s3,8(sp)
    80001792:	e052                	sd	s4,0(sp)
    80001794:	1800                	addi	s0,sp,48
    80001796:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001798:	00007497          	auipc	s1,0x7
    8000179c:	64848493          	addi	s1,s1,1608 # 80008de0 <proc>
      pp->parent = initproc;
    800017a0:	00007a17          	auipc	s4,0x7
    800017a4:	1d0a0a13          	addi	s4,s4,464 # 80008970 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800017a8:	0000d997          	auipc	s3,0xd
    800017ac:	23898993          	addi	s3,s3,568 # 8000e9e0 <tickslock>
    800017b0:	a029                	j	800017ba <reparent+0x34>
    800017b2:	17048493          	addi	s1,s1,368
    800017b6:	01348d63          	beq	s1,s3,800017d0 <reparent+0x4a>
    if(pp->parent == p){
    800017ba:	7c9c                	ld	a5,56(s1)
    800017bc:	ff279be3          	bne	a5,s2,800017b2 <reparent+0x2c>
      pp->parent = initproc;
    800017c0:	000a3503          	ld	a0,0(s4)
    800017c4:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800017c6:	00000097          	auipc	ra,0x0
    800017ca:	f4a080e7          	jalr	-182(ra) # 80001710 <wakeup>
    800017ce:	b7d5                	j	800017b2 <reparent+0x2c>
}
    800017d0:	70a2                	ld	ra,40(sp)
    800017d2:	7402                	ld	s0,32(sp)
    800017d4:	64e2                	ld	s1,24(sp)
    800017d6:	6942                	ld	s2,16(sp)
    800017d8:	69a2                	ld	s3,8(sp)
    800017da:	6a02                	ld	s4,0(sp)
    800017dc:	6145                	addi	sp,sp,48
    800017de:	8082                	ret

00000000800017e0 <exit>:
{
    800017e0:	7179                	addi	sp,sp,-48
    800017e2:	f406                	sd	ra,40(sp)
    800017e4:	f022                	sd	s0,32(sp)
    800017e6:	ec26                	sd	s1,24(sp)
    800017e8:	e84a                	sd	s2,16(sp)
    800017ea:	e44e                	sd	s3,8(sp)
    800017ec:	e052                	sd	s4,0(sp)
    800017ee:	1800                	addi	s0,sp,48
    800017f0:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800017f2:	fffff097          	auipc	ra,0xfffff
    800017f6:	74e080e7          	jalr	1870(ra) # 80000f40 <myproc>
    800017fa:	89aa                	mv	s3,a0
  if(p == initproc)
    800017fc:	00007797          	auipc	a5,0x7
    80001800:	1747b783          	ld	a5,372(a5) # 80008970 <initproc>
    80001804:	0d050493          	addi	s1,a0,208
    80001808:	15050913          	addi	s2,a0,336
    8000180c:	02a79363          	bne	a5,a0,80001832 <exit+0x52>
    panic("init exiting");
    80001810:	00007517          	auipc	a0,0x7
    80001814:	a3050513          	addi	a0,a0,-1488 # 80008240 <etext+0x240>
    80001818:	00004097          	auipc	ra,0x4
    8000181c:	65a080e7          	jalr	1626(ra) # 80005e72 <panic>
      fileclose(f);
    80001820:	00002097          	auipc	ra,0x2
    80001824:	3da080e7          	jalr	986(ra) # 80003bfa <fileclose>
      p->ofile[fd] = 0;
    80001828:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    8000182c:	04a1                	addi	s1,s1,8
    8000182e:	01248563          	beq	s1,s2,80001838 <exit+0x58>
    if(p->ofile[fd]){
    80001832:	6088                	ld	a0,0(s1)
    80001834:	f575                	bnez	a0,80001820 <exit+0x40>
    80001836:	bfdd                	j	8000182c <exit+0x4c>
  begin_op();
    80001838:	00002097          	auipc	ra,0x2
    8000183c:	ef6080e7          	jalr	-266(ra) # 8000372e <begin_op>
  iput(p->cwd);
    80001840:	1509b503          	ld	a0,336(s3)
    80001844:	00001097          	auipc	ra,0x1
    80001848:	6e2080e7          	jalr	1762(ra) # 80002f26 <iput>
  end_op();
    8000184c:	00002097          	auipc	ra,0x2
    80001850:	f62080e7          	jalr	-158(ra) # 800037ae <end_op>
  p->cwd = 0;
    80001854:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001858:	00007497          	auipc	s1,0x7
    8000185c:	17048493          	addi	s1,s1,368 # 800089c8 <wait_lock>
    80001860:	8526                	mv	a0,s1
    80001862:	00005097          	auipc	ra,0x5
    80001866:	b5a080e7          	jalr	-1190(ra) # 800063bc <acquire>
  reparent(p);
    8000186a:	854e                	mv	a0,s3
    8000186c:	00000097          	auipc	ra,0x0
    80001870:	f1a080e7          	jalr	-230(ra) # 80001786 <reparent>
  wakeup(p->parent);
    80001874:	0389b503          	ld	a0,56(s3)
    80001878:	00000097          	auipc	ra,0x0
    8000187c:	e98080e7          	jalr	-360(ra) # 80001710 <wakeup>
  acquire(&p->lock);
    80001880:	854e                	mv	a0,s3
    80001882:	00005097          	auipc	ra,0x5
    80001886:	b3a080e7          	jalr	-1222(ra) # 800063bc <acquire>
  p->xstate = status;
    8000188a:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    8000188e:	4795                	li	a5,5
    80001890:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001894:	8526                	mv	a0,s1
    80001896:	00005097          	auipc	ra,0x5
    8000189a:	bda080e7          	jalr	-1062(ra) # 80006470 <release>
  sched();
    8000189e:	00000097          	auipc	ra,0x0
    800018a2:	cfc080e7          	jalr	-772(ra) # 8000159a <sched>
  panic("zombie exit");
    800018a6:	00007517          	auipc	a0,0x7
    800018aa:	9aa50513          	addi	a0,a0,-1622 # 80008250 <etext+0x250>
    800018ae:	00004097          	auipc	ra,0x4
    800018b2:	5c4080e7          	jalr	1476(ra) # 80005e72 <panic>

00000000800018b6 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800018b6:	7179                	addi	sp,sp,-48
    800018b8:	f406                	sd	ra,40(sp)
    800018ba:	f022                	sd	s0,32(sp)
    800018bc:	ec26                	sd	s1,24(sp)
    800018be:	e84a                	sd	s2,16(sp)
    800018c0:	e44e                	sd	s3,8(sp)
    800018c2:	1800                	addi	s0,sp,48
    800018c4:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800018c6:	00007497          	auipc	s1,0x7
    800018ca:	51a48493          	addi	s1,s1,1306 # 80008de0 <proc>
    800018ce:	0000d997          	auipc	s3,0xd
    800018d2:	11298993          	addi	s3,s3,274 # 8000e9e0 <tickslock>
    acquire(&p->lock);
    800018d6:	8526                	mv	a0,s1
    800018d8:	00005097          	auipc	ra,0x5
    800018dc:	ae4080e7          	jalr	-1308(ra) # 800063bc <acquire>
    if(p->pid == pid){
    800018e0:	589c                	lw	a5,48(s1)
    800018e2:	01278d63          	beq	a5,s2,800018fc <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800018e6:	8526                	mv	a0,s1
    800018e8:	00005097          	auipc	ra,0x5
    800018ec:	b88080e7          	jalr	-1144(ra) # 80006470 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800018f0:	17048493          	addi	s1,s1,368
    800018f4:	ff3491e3          	bne	s1,s3,800018d6 <kill+0x20>
  }
  return -1;
    800018f8:	557d                	li	a0,-1
    800018fa:	a829                	j	80001914 <kill+0x5e>
      p->killed = 1;
    800018fc:	4785                	li	a5,1
    800018fe:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001900:	4c98                	lw	a4,24(s1)
    80001902:	4789                	li	a5,2
    80001904:	00f70f63          	beq	a4,a5,80001922 <kill+0x6c>
      release(&p->lock);
    80001908:	8526                	mv	a0,s1
    8000190a:	00005097          	auipc	ra,0x5
    8000190e:	b66080e7          	jalr	-1178(ra) # 80006470 <release>
      return 0;
    80001912:	4501                	li	a0,0
}
    80001914:	70a2                	ld	ra,40(sp)
    80001916:	7402                	ld	s0,32(sp)
    80001918:	64e2                	ld	s1,24(sp)
    8000191a:	6942                	ld	s2,16(sp)
    8000191c:	69a2                	ld	s3,8(sp)
    8000191e:	6145                	addi	sp,sp,48
    80001920:	8082                	ret
        p->state = RUNNABLE;
    80001922:	478d                	li	a5,3
    80001924:	cc9c                	sw	a5,24(s1)
    80001926:	b7cd                	j	80001908 <kill+0x52>

0000000080001928 <setkilled>:

void
setkilled(struct proc *p)
{
    80001928:	1101                	addi	sp,sp,-32
    8000192a:	ec06                	sd	ra,24(sp)
    8000192c:	e822                	sd	s0,16(sp)
    8000192e:	e426                	sd	s1,8(sp)
    80001930:	1000                	addi	s0,sp,32
    80001932:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001934:	00005097          	auipc	ra,0x5
    80001938:	a88080e7          	jalr	-1400(ra) # 800063bc <acquire>
  p->killed = 1;
    8000193c:	4785                	li	a5,1
    8000193e:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001940:	8526                	mv	a0,s1
    80001942:	00005097          	auipc	ra,0x5
    80001946:	b2e080e7          	jalr	-1234(ra) # 80006470 <release>
}
    8000194a:	60e2                	ld	ra,24(sp)
    8000194c:	6442                	ld	s0,16(sp)
    8000194e:	64a2                	ld	s1,8(sp)
    80001950:	6105                	addi	sp,sp,32
    80001952:	8082                	ret

0000000080001954 <killed>:

int
killed(struct proc *p)
{
    80001954:	1101                	addi	sp,sp,-32
    80001956:	ec06                	sd	ra,24(sp)
    80001958:	e822                	sd	s0,16(sp)
    8000195a:	e426                	sd	s1,8(sp)
    8000195c:	e04a                	sd	s2,0(sp)
    8000195e:	1000                	addi	s0,sp,32
    80001960:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80001962:	00005097          	auipc	ra,0x5
    80001966:	a5a080e7          	jalr	-1446(ra) # 800063bc <acquire>
  k = p->killed;
    8000196a:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    8000196e:	8526                	mv	a0,s1
    80001970:	00005097          	auipc	ra,0x5
    80001974:	b00080e7          	jalr	-1280(ra) # 80006470 <release>
  return k;
}
    80001978:	854a                	mv	a0,s2
    8000197a:	60e2                	ld	ra,24(sp)
    8000197c:	6442                	ld	s0,16(sp)
    8000197e:	64a2                	ld	s1,8(sp)
    80001980:	6902                	ld	s2,0(sp)
    80001982:	6105                	addi	sp,sp,32
    80001984:	8082                	ret

0000000080001986 <wait>:
{
    80001986:	715d                	addi	sp,sp,-80
    80001988:	e486                	sd	ra,72(sp)
    8000198a:	e0a2                	sd	s0,64(sp)
    8000198c:	fc26                	sd	s1,56(sp)
    8000198e:	f84a                	sd	s2,48(sp)
    80001990:	f44e                	sd	s3,40(sp)
    80001992:	f052                	sd	s4,32(sp)
    80001994:	ec56                	sd	s5,24(sp)
    80001996:	e85a                	sd	s6,16(sp)
    80001998:	e45e                	sd	s7,8(sp)
    8000199a:	e062                	sd	s8,0(sp)
    8000199c:	0880                	addi	s0,sp,80
    8000199e:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800019a0:	fffff097          	auipc	ra,0xfffff
    800019a4:	5a0080e7          	jalr	1440(ra) # 80000f40 <myproc>
    800019a8:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800019aa:	00007517          	auipc	a0,0x7
    800019ae:	01e50513          	addi	a0,a0,30 # 800089c8 <wait_lock>
    800019b2:	00005097          	auipc	ra,0x5
    800019b6:	a0a080e7          	jalr	-1526(ra) # 800063bc <acquire>
    havekids = 0;
    800019ba:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    800019bc:	4a15                	li	s4,5
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800019be:	0000d997          	auipc	s3,0xd
    800019c2:	02298993          	addi	s3,s3,34 # 8000e9e0 <tickslock>
        havekids = 1;
    800019c6:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800019c8:	00007c17          	auipc	s8,0x7
    800019cc:	000c0c13          	mv	s8,s8
    havekids = 0;
    800019d0:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800019d2:	00007497          	auipc	s1,0x7
    800019d6:	40e48493          	addi	s1,s1,1038 # 80008de0 <proc>
    800019da:	a0bd                	j	80001a48 <wait+0xc2>
          pid = pp->pid;
    800019dc:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800019e0:	000b0e63          	beqz	s6,800019fc <wait+0x76>
    800019e4:	4691                	li	a3,4
    800019e6:	02c48613          	addi	a2,s1,44
    800019ea:	85da                	mv	a1,s6
    800019ec:	05093503          	ld	a0,80(s2)
    800019f0:	fffff097          	auipc	ra,0xfffff
    800019f4:	126080e7          	jalr	294(ra) # 80000b16 <copyout>
    800019f8:	02054563          	bltz	a0,80001a22 <wait+0x9c>
          freeproc(pp);
    800019fc:	8526                	mv	a0,s1
    800019fe:	fffff097          	auipc	ra,0xfffff
    80001a02:	77e080e7          	jalr	1918(ra) # 8000117c <freeproc>
          release(&pp->lock);
    80001a06:	8526                	mv	a0,s1
    80001a08:	00005097          	auipc	ra,0x5
    80001a0c:	a68080e7          	jalr	-1432(ra) # 80006470 <release>
          release(&wait_lock);
    80001a10:	00007517          	auipc	a0,0x7
    80001a14:	fb850513          	addi	a0,a0,-72 # 800089c8 <wait_lock>
    80001a18:	00005097          	auipc	ra,0x5
    80001a1c:	a58080e7          	jalr	-1448(ra) # 80006470 <release>
          return pid;
    80001a20:	a0b5                	j	80001a8c <wait+0x106>
            release(&pp->lock);
    80001a22:	8526                	mv	a0,s1
    80001a24:	00005097          	auipc	ra,0x5
    80001a28:	a4c080e7          	jalr	-1460(ra) # 80006470 <release>
            release(&wait_lock);
    80001a2c:	00007517          	auipc	a0,0x7
    80001a30:	f9c50513          	addi	a0,a0,-100 # 800089c8 <wait_lock>
    80001a34:	00005097          	auipc	ra,0x5
    80001a38:	a3c080e7          	jalr	-1476(ra) # 80006470 <release>
            return -1;
    80001a3c:	59fd                	li	s3,-1
    80001a3e:	a0b9                	j	80001a8c <wait+0x106>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001a40:	17048493          	addi	s1,s1,368
    80001a44:	03348463          	beq	s1,s3,80001a6c <wait+0xe6>
      if(pp->parent == p){
    80001a48:	7c9c                	ld	a5,56(s1)
    80001a4a:	ff279be3          	bne	a5,s2,80001a40 <wait+0xba>
        acquire(&pp->lock);
    80001a4e:	8526                	mv	a0,s1
    80001a50:	00005097          	auipc	ra,0x5
    80001a54:	96c080e7          	jalr	-1684(ra) # 800063bc <acquire>
        if(pp->state == ZOMBIE){
    80001a58:	4c9c                	lw	a5,24(s1)
    80001a5a:	f94781e3          	beq	a5,s4,800019dc <wait+0x56>
        release(&pp->lock);
    80001a5e:	8526                	mv	a0,s1
    80001a60:	00005097          	auipc	ra,0x5
    80001a64:	a10080e7          	jalr	-1520(ra) # 80006470 <release>
        havekids = 1;
    80001a68:	8756                	mv	a4,s5
    80001a6a:	bfd9                	j	80001a40 <wait+0xba>
    if(!havekids || killed(p)){
    80001a6c:	c719                	beqz	a4,80001a7a <wait+0xf4>
    80001a6e:	854a                	mv	a0,s2
    80001a70:	00000097          	auipc	ra,0x0
    80001a74:	ee4080e7          	jalr	-284(ra) # 80001954 <killed>
    80001a78:	c51d                	beqz	a0,80001aa6 <wait+0x120>
      release(&wait_lock);
    80001a7a:	00007517          	auipc	a0,0x7
    80001a7e:	f4e50513          	addi	a0,a0,-178 # 800089c8 <wait_lock>
    80001a82:	00005097          	auipc	ra,0x5
    80001a86:	9ee080e7          	jalr	-1554(ra) # 80006470 <release>
      return -1;
    80001a8a:	59fd                	li	s3,-1
}
    80001a8c:	854e                	mv	a0,s3
    80001a8e:	60a6                	ld	ra,72(sp)
    80001a90:	6406                	ld	s0,64(sp)
    80001a92:	74e2                	ld	s1,56(sp)
    80001a94:	7942                	ld	s2,48(sp)
    80001a96:	79a2                	ld	s3,40(sp)
    80001a98:	7a02                	ld	s4,32(sp)
    80001a9a:	6ae2                	ld	s5,24(sp)
    80001a9c:	6b42                	ld	s6,16(sp)
    80001a9e:	6ba2                	ld	s7,8(sp)
    80001aa0:	6c02                	ld	s8,0(sp)
    80001aa2:	6161                	addi	sp,sp,80
    80001aa4:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001aa6:	85e2                	mv	a1,s8
    80001aa8:	854a                	mv	a0,s2
    80001aaa:	00000097          	auipc	ra,0x0
    80001aae:	c02080e7          	jalr	-1022(ra) # 800016ac <sleep>
    havekids = 0;
    80001ab2:	bf39                	j	800019d0 <wait+0x4a>

0000000080001ab4 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001ab4:	7179                	addi	sp,sp,-48
    80001ab6:	f406                	sd	ra,40(sp)
    80001ab8:	f022                	sd	s0,32(sp)
    80001aba:	ec26                	sd	s1,24(sp)
    80001abc:	e84a                	sd	s2,16(sp)
    80001abe:	e44e                	sd	s3,8(sp)
    80001ac0:	e052                	sd	s4,0(sp)
    80001ac2:	1800                	addi	s0,sp,48
    80001ac4:	84aa                	mv	s1,a0
    80001ac6:	892e                	mv	s2,a1
    80001ac8:	89b2                	mv	s3,a2
    80001aca:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001acc:	fffff097          	auipc	ra,0xfffff
    80001ad0:	474080e7          	jalr	1140(ra) # 80000f40 <myproc>
  if(user_dst){
    80001ad4:	c08d                	beqz	s1,80001af6 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001ad6:	86d2                	mv	a3,s4
    80001ad8:	864e                	mv	a2,s3
    80001ada:	85ca                	mv	a1,s2
    80001adc:	6928                	ld	a0,80(a0)
    80001ade:	fffff097          	auipc	ra,0xfffff
    80001ae2:	038080e7          	jalr	56(ra) # 80000b16 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001ae6:	70a2                	ld	ra,40(sp)
    80001ae8:	7402                	ld	s0,32(sp)
    80001aea:	64e2                	ld	s1,24(sp)
    80001aec:	6942                	ld	s2,16(sp)
    80001aee:	69a2                	ld	s3,8(sp)
    80001af0:	6a02                	ld	s4,0(sp)
    80001af2:	6145                	addi	sp,sp,48
    80001af4:	8082                	ret
    memmove((char *)dst, src, len);
    80001af6:	000a061b          	sext.w	a2,s4
    80001afa:	85ce                	mv	a1,s3
    80001afc:	854a                	mv	a0,s2
    80001afe:	ffffe097          	auipc	ra,0xffffe
    80001b02:	6da080e7          	jalr	1754(ra) # 800001d8 <memmove>
    return 0;
    80001b06:	8526                	mv	a0,s1
    80001b08:	bff9                	j	80001ae6 <either_copyout+0x32>

0000000080001b0a <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001b0a:	7179                	addi	sp,sp,-48
    80001b0c:	f406                	sd	ra,40(sp)
    80001b0e:	f022                	sd	s0,32(sp)
    80001b10:	ec26                	sd	s1,24(sp)
    80001b12:	e84a                	sd	s2,16(sp)
    80001b14:	e44e                	sd	s3,8(sp)
    80001b16:	e052                	sd	s4,0(sp)
    80001b18:	1800                	addi	s0,sp,48
    80001b1a:	892a                	mv	s2,a0
    80001b1c:	84ae                	mv	s1,a1
    80001b1e:	89b2                	mv	s3,a2
    80001b20:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001b22:	fffff097          	auipc	ra,0xfffff
    80001b26:	41e080e7          	jalr	1054(ra) # 80000f40 <myproc>
  if(user_src){
    80001b2a:	c08d                	beqz	s1,80001b4c <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001b2c:	86d2                	mv	a3,s4
    80001b2e:	864e                	mv	a2,s3
    80001b30:	85ca                	mv	a1,s2
    80001b32:	6928                	ld	a0,80(a0)
    80001b34:	fffff097          	auipc	ra,0xfffff
    80001b38:	06e080e7          	jalr	110(ra) # 80000ba2 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001b3c:	70a2                	ld	ra,40(sp)
    80001b3e:	7402                	ld	s0,32(sp)
    80001b40:	64e2                	ld	s1,24(sp)
    80001b42:	6942                	ld	s2,16(sp)
    80001b44:	69a2                	ld	s3,8(sp)
    80001b46:	6a02                	ld	s4,0(sp)
    80001b48:	6145                	addi	sp,sp,48
    80001b4a:	8082                	ret
    memmove(dst, (char*)src, len);
    80001b4c:	000a061b          	sext.w	a2,s4
    80001b50:	85ce                	mv	a1,s3
    80001b52:	854a                	mv	a0,s2
    80001b54:	ffffe097          	auipc	ra,0xffffe
    80001b58:	684080e7          	jalr	1668(ra) # 800001d8 <memmove>
    return 0;
    80001b5c:	8526                	mv	a0,s1
    80001b5e:	bff9                	j	80001b3c <either_copyin+0x32>

0000000080001b60 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001b60:	715d                	addi	sp,sp,-80
    80001b62:	e486                	sd	ra,72(sp)
    80001b64:	e0a2                	sd	s0,64(sp)
    80001b66:	fc26                	sd	s1,56(sp)
    80001b68:	f84a                	sd	s2,48(sp)
    80001b6a:	f44e                	sd	s3,40(sp)
    80001b6c:	f052                	sd	s4,32(sp)
    80001b6e:	ec56                	sd	s5,24(sp)
    80001b70:	e85a                	sd	s6,16(sp)
    80001b72:	e45e                	sd	s7,8(sp)
    80001b74:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001b76:	00006517          	auipc	a0,0x6
    80001b7a:	4d250513          	addi	a0,a0,1234 # 80008048 <etext+0x48>
    80001b7e:	00004097          	auipc	ra,0x4
    80001b82:	33e080e7          	jalr	830(ra) # 80005ebc <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b86:	00007497          	auipc	s1,0x7
    80001b8a:	3b248493          	addi	s1,s1,946 # 80008f38 <proc+0x158>
    80001b8e:	0000d917          	auipc	s2,0xd
    80001b92:	faa90913          	addi	s2,s2,-86 # 8000eb38 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b96:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001b98:	00006997          	auipc	s3,0x6
    80001b9c:	6c898993          	addi	s3,s3,1736 # 80008260 <etext+0x260>
    printf("%d %s %s", p->pid, state, p->name);
    80001ba0:	00006a97          	auipc	s5,0x6
    80001ba4:	6c8a8a93          	addi	s5,s5,1736 # 80008268 <etext+0x268>
    printf("\n");
    80001ba8:	00006a17          	auipc	s4,0x6
    80001bac:	4a0a0a13          	addi	s4,s4,1184 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001bb0:	00006b97          	auipc	s7,0x6
    80001bb4:	6f8b8b93          	addi	s7,s7,1784 # 800082a8 <states.1727>
    80001bb8:	a00d                	j	80001bda <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001bba:	ed86a583          	lw	a1,-296(a3)
    80001bbe:	8556                	mv	a0,s5
    80001bc0:	00004097          	auipc	ra,0x4
    80001bc4:	2fc080e7          	jalr	764(ra) # 80005ebc <printf>
    printf("\n");
    80001bc8:	8552                	mv	a0,s4
    80001bca:	00004097          	auipc	ra,0x4
    80001bce:	2f2080e7          	jalr	754(ra) # 80005ebc <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001bd2:	17048493          	addi	s1,s1,368
    80001bd6:	03248163          	beq	s1,s2,80001bf8 <procdump+0x98>
    if(p->state == UNUSED)
    80001bda:	86a6                	mv	a3,s1
    80001bdc:	ec04a783          	lw	a5,-320(s1)
    80001be0:	dbed                	beqz	a5,80001bd2 <procdump+0x72>
      state = "???";
    80001be2:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001be4:	fcfb6be3          	bltu	s6,a5,80001bba <procdump+0x5a>
    80001be8:	1782                	slli	a5,a5,0x20
    80001bea:	9381                	srli	a5,a5,0x20
    80001bec:	078e                	slli	a5,a5,0x3
    80001bee:	97de                	add	a5,a5,s7
    80001bf0:	6390                	ld	a2,0(a5)
    80001bf2:	f661                	bnez	a2,80001bba <procdump+0x5a>
      state = "???";
    80001bf4:	864e                	mv	a2,s3
    80001bf6:	b7d1                	j	80001bba <procdump+0x5a>
  }
}
    80001bf8:	60a6                	ld	ra,72(sp)
    80001bfa:	6406                	ld	s0,64(sp)
    80001bfc:	74e2                	ld	s1,56(sp)
    80001bfe:	7942                	ld	s2,48(sp)
    80001c00:	79a2                	ld	s3,40(sp)
    80001c02:	7a02                	ld	s4,32(sp)
    80001c04:	6ae2                	ld	s5,24(sp)
    80001c06:	6b42                	ld	s6,16(sp)
    80001c08:	6ba2                	ld	s7,8(sp)
    80001c0a:	6161                	addi	sp,sp,80
    80001c0c:	8082                	ret

0000000080001c0e <swtch>:
    80001c0e:	00153023          	sd	ra,0(a0)
    80001c12:	00253423          	sd	sp,8(a0)
    80001c16:	e900                	sd	s0,16(a0)
    80001c18:	ed04                	sd	s1,24(a0)
    80001c1a:	03253023          	sd	s2,32(a0)
    80001c1e:	03353423          	sd	s3,40(a0)
    80001c22:	03453823          	sd	s4,48(a0)
    80001c26:	03553c23          	sd	s5,56(a0)
    80001c2a:	05653023          	sd	s6,64(a0)
    80001c2e:	05753423          	sd	s7,72(a0)
    80001c32:	05853823          	sd	s8,80(a0)
    80001c36:	05953c23          	sd	s9,88(a0)
    80001c3a:	07a53023          	sd	s10,96(a0)
    80001c3e:	07b53423          	sd	s11,104(a0)
    80001c42:	0005b083          	ld	ra,0(a1)
    80001c46:	0085b103          	ld	sp,8(a1)
    80001c4a:	6980                	ld	s0,16(a1)
    80001c4c:	6d84                	ld	s1,24(a1)
    80001c4e:	0205b903          	ld	s2,32(a1)
    80001c52:	0285b983          	ld	s3,40(a1)
    80001c56:	0305ba03          	ld	s4,48(a1)
    80001c5a:	0385ba83          	ld	s5,56(a1)
    80001c5e:	0405bb03          	ld	s6,64(a1)
    80001c62:	0485bb83          	ld	s7,72(a1)
    80001c66:	0505bc03          	ld	s8,80(a1)
    80001c6a:	0585bc83          	ld	s9,88(a1)
    80001c6e:	0605bd03          	ld	s10,96(a1)
    80001c72:	0685bd83          	ld	s11,104(a1)
    80001c76:	8082                	ret

0000000080001c78 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001c78:	1141                	addi	sp,sp,-16
    80001c7a:	e406                	sd	ra,8(sp)
    80001c7c:	e022                	sd	s0,0(sp)
    80001c7e:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001c80:	00006597          	auipc	a1,0x6
    80001c84:	65858593          	addi	a1,a1,1624 # 800082d8 <states.1727+0x30>
    80001c88:	0000d517          	auipc	a0,0xd
    80001c8c:	d5850513          	addi	a0,a0,-680 # 8000e9e0 <tickslock>
    80001c90:	00004097          	auipc	ra,0x4
    80001c94:	69c080e7          	jalr	1692(ra) # 8000632c <initlock>
}
    80001c98:	60a2                	ld	ra,8(sp)
    80001c9a:	6402                	ld	s0,0(sp)
    80001c9c:	0141                	addi	sp,sp,16
    80001c9e:	8082                	ret

0000000080001ca0 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001ca0:	1141                	addi	sp,sp,-16
    80001ca2:	e422                	sd	s0,8(sp)
    80001ca4:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001ca6:	00003797          	auipc	a5,0x3
    80001caa:	59a78793          	addi	a5,a5,1434 # 80005240 <kernelvec>
    80001cae:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001cb2:	6422                	ld	s0,8(sp)
    80001cb4:	0141                	addi	sp,sp,16
    80001cb6:	8082                	ret

0000000080001cb8 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001cb8:	1141                	addi	sp,sp,-16
    80001cba:	e406                	sd	ra,8(sp)
    80001cbc:	e022                	sd	s0,0(sp)
    80001cbe:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001cc0:	fffff097          	auipc	ra,0xfffff
    80001cc4:	280080e7          	jalr	640(ra) # 80000f40 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cc8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001ccc:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001cce:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001cd2:	00005617          	auipc	a2,0x5
    80001cd6:	32e60613          	addi	a2,a2,814 # 80007000 <_trampoline>
    80001cda:	00005697          	auipc	a3,0x5
    80001cde:	32668693          	addi	a3,a3,806 # 80007000 <_trampoline>
    80001ce2:	8e91                	sub	a3,a3,a2
    80001ce4:	040007b7          	lui	a5,0x4000
    80001ce8:	17fd                	addi	a5,a5,-1
    80001cea:	07b2                	slli	a5,a5,0xc
    80001cec:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cee:	10569073          	csrw	stvec,a3
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001cf2:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001cf4:	180026f3          	csrr	a3,satp
    80001cf8:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001cfa:	6d38                	ld	a4,88(a0)
    80001cfc:	6134                	ld	a3,64(a0)
    80001cfe:	6585                	lui	a1,0x1
    80001d00:	96ae                	add	a3,a3,a1
    80001d02:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001d04:	6d38                	ld	a4,88(a0)
    80001d06:	00000697          	auipc	a3,0x0
    80001d0a:	13068693          	addi	a3,a3,304 # 80001e36 <usertrap>
    80001d0e:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001d10:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001d12:	8692                	mv	a3,tp
    80001d14:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d16:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001d1a:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001d1e:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d22:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001d26:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001d28:	6f18                	ld	a4,24(a4)
    80001d2a:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001d2e:	6928                	ld	a0,80(a0)
    80001d30:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001d32:	00005717          	auipc	a4,0x5
    80001d36:	36a70713          	addi	a4,a4,874 # 8000709c <userret>
    80001d3a:	8f11                	sub	a4,a4,a2
    80001d3c:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001d3e:	577d                	li	a4,-1
    80001d40:	177e                	slli	a4,a4,0x3f
    80001d42:	8d59                	or	a0,a0,a4
    80001d44:	9782                	jalr	a5
}
    80001d46:	60a2                	ld	ra,8(sp)
    80001d48:	6402                	ld	s0,0(sp)
    80001d4a:	0141                	addi	sp,sp,16
    80001d4c:	8082                	ret

0000000080001d4e <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001d4e:	1101                	addi	sp,sp,-32
    80001d50:	ec06                	sd	ra,24(sp)
    80001d52:	e822                	sd	s0,16(sp)
    80001d54:	e426                	sd	s1,8(sp)
    80001d56:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001d58:	0000d497          	auipc	s1,0xd
    80001d5c:	c8848493          	addi	s1,s1,-888 # 8000e9e0 <tickslock>
    80001d60:	8526                	mv	a0,s1
    80001d62:	00004097          	auipc	ra,0x4
    80001d66:	65a080e7          	jalr	1626(ra) # 800063bc <acquire>
  ticks++;
    80001d6a:	00007517          	auipc	a0,0x7
    80001d6e:	c0e50513          	addi	a0,a0,-1010 # 80008978 <ticks>
    80001d72:	411c                	lw	a5,0(a0)
    80001d74:	2785                	addiw	a5,a5,1
    80001d76:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001d78:	00000097          	auipc	ra,0x0
    80001d7c:	998080e7          	jalr	-1640(ra) # 80001710 <wakeup>
  release(&tickslock);
    80001d80:	8526                	mv	a0,s1
    80001d82:	00004097          	auipc	ra,0x4
    80001d86:	6ee080e7          	jalr	1774(ra) # 80006470 <release>
}
    80001d8a:	60e2                	ld	ra,24(sp)
    80001d8c:	6442                	ld	s0,16(sp)
    80001d8e:	64a2                	ld	s1,8(sp)
    80001d90:	6105                	addi	sp,sp,32
    80001d92:	8082                	ret

0000000080001d94 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001d94:	1101                	addi	sp,sp,-32
    80001d96:	ec06                	sd	ra,24(sp)
    80001d98:	e822                	sd	s0,16(sp)
    80001d9a:	e426                	sd	s1,8(sp)
    80001d9c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d9e:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001da2:	00074d63          	bltz	a4,80001dbc <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001da6:	57fd                	li	a5,-1
    80001da8:	17fe                	slli	a5,a5,0x3f
    80001daa:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001dac:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001dae:	06f70363          	beq	a4,a5,80001e14 <devintr+0x80>
  }
}
    80001db2:	60e2                	ld	ra,24(sp)
    80001db4:	6442                	ld	s0,16(sp)
    80001db6:	64a2                	ld	s1,8(sp)
    80001db8:	6105                	addi	sp,sp,32
    80001dba:	8082                	ret
     (scause & 0xff) == 9){
    80001dbc:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001dc0:	46a5                	li	a3,9
    80001dc2:	fed792e3          	bne	a5,a3,80001da6 <devintr+0x12>
    int irq = plic_claim();
    80001dc6:	00003097          	auipc	ra,0x3
    80001dca:	582080e7          	jalr	1410(ra) # 80005348 <plic_claim>
    80001dce:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001dd0:	47a9                	li	a5,10
    80001dd2:	02f50763          	beq	a0,a5,80001e00 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001dd6:	4785                	li	a5,1
    80001dd8:	02f50963          	beq	a0,a5,80001e0a <devintr+0x76>
    return 1;
    80001ddc:	4505                	li	a0,1
    } else if(irq){
    80001dde:	d8f1                	beqz	s1,80001db2 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001de0:	85a6                	mv	a1,s1
    80001de2:	00006517          	auipc	a0,0x6
    80001de6:	4fe50513          	addi	a0,a0,1278 # 800082e0 <states.1727+0x38>
    80001dea:	00004097          	auipc	ra,0x4
    80001dee:	0d2080e7          	jalr	210(ra) # 80005ebc <printf>
      plic_complete(irq);
    80001df2:	8526                	mv	a0,s1
    80001df4:	00003097          	auipc	ra,0x3
    80001df8:	578080e7          	jalr	1400(ra) # 8000536c <plic_complete>
    return 1;
    80001dfc:	4505                	li	a0,1
    80001dfe:	bf55                	j	80001db2 <devintr+0x1e>
      uartintr();
    80001e00:	00004097          	auipc	ra,0x4
    80001e04:	4dc080e7          	jalr	1244(ra) # 800062dc <uartintr>
    80001e08:	b7ed                	j	80001df2 <devintr+0x5e>
      virtio_disk_intr();
    80001e0a:	00004097          	auipc	ra,0x4
    80001e0e:	a8c080e7          	jalr	-1396(ra) # 80005896 <virtio_disk_intr>
    80001e12:	b7c5                	j	80001df2 <devintr+0x5e>
    if(cpuid() == 0){
    80001e14:	fffff097          	auipc	ra,0xfffff
    80001e18:	100080e7          	jalr	256(ra) # 80000f14 <cpuid>
    80001e1c:	c901                	beqz	a0,80001e2c <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001e1e:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001e22:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001e24:	14479073          	csrw	sip,a5
    return 2;
    80001e28:	4509                	li	a0,2
    80001e2a:	b761                	j	80001db2 <devintr+0x1e>
      clockintr();
    80001e2c:	00000097          	auipc	ra,0x0
    80001e30:	f22080e7          	jalr	-222(ra) # 80001d4e <clockintr>
    80001e34:	b7ed                	j	80001e1e <devintr+0x8a>

0000000080001e36 <usertrap>:
{
    80001e36:	1101                	addi	sp,sp,-32
    80001e38:	ec06                	sd	ra,24(sp)
    80001e3a:	e822                	sd	s0,16(sp)
    80001e3c:	e426                	sd	s1,8(sp)
    80001e3e:	e04a                	sd	s2,0(sp)
    80001e40:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e42:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001e46:	1007f793          	andi	a5,a5,256
    80001e4a:	e3b1                	bnez	a5,80001e8e <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001e4c:	00003797          	auipc	a5,0x3
    80001e50:	3f478793          	addi	a5,a5,1012 # 80005240 <kernelvec>
    80001e54:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001e58:	fffff097          	auipc	ra,0xfffff
    80001e5c:	0e8080e7          	jalr	232(ra) # 80000f40 <myproc>
    80001e60:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001e62:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e64:	14102773          	csrr	a4,sepc
    80001e68:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e6a:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001e6e:	47a1                	li	a5,8
    80001e70:	02f70763          	beq	a4,a5,80001e9e <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    80001e74:	00000097          	auipc	ra,0x0
    80001e78:	f20080e7          	jalr	-224(ra) # 80001d94 <devintr>
    80001e7c:	892a                	mv	s2,a0
    80001e7e:	c151                	beqz	a0,80001f02 <usertrap+0xcc>
  if(killed(p))
    80001e80:	8526                	mv	a0,s1
    80001e82:	00000097          	auipc	ra,0x0
    80001e86:	ad2080e7          	jalr	-1326(ra) # 80001954 <killed>
    80001e8a:	c929                	beqz	a0,80001edc <usertrap+0xa6>
    80001e8c:	a099                	j	80001ed2 <usertrap+0x9c>
    panic("usertrap: not from user mode");
    80001e8e:	00006517          	auipc	a0,0x6
    80001e92:	47250513          	addi	a0,a0,1138 # 80008300 <states.1727+0x58>
    80001e96:	00004097          	auipc	ra,0x4
    80001e9a:	fdc080e7          	jalr	-36(ra) # 80005e72 <panic>
    if(killed(p))
    80001e9e:	00000097          	auipc	ra,0x0
    80001ea2:	ab6080e7          	jalr	-1354(ra) # 80001954 <killed>
    80001ea6:	e921                	bnez	a0,80001ef6 <usertrap+0xc0>
    p->trapframe->epc += 4;
    80001ea8:	6cb8                	ld	a4,88(s1)
    80001eaa:	6f1c                	ld	a5,24(a4)
    80001eac:	0791                	addi	a5,a5,4
    80001eae:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001eb0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001eb4:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001eb8:	10079073          	csrw	sstatus,a5
    syscall();
    80001ebc:	00000097          	auipc	ra,0x0
    80001ec0:	2d4080e7          	jalr	724(ra) # 80002190 <syscall>
  if(killed(p))
    80001ec4:	8526                	mv	a0,s1
    80001ec6:	00000097          	auipc	ra,0x0
    80001eca:	a8e080e7          	jalr	-1394(ra) # 80001954 <killed>
    80001ece:	c911                	beqz	a0,80001ee2 <usertrap+0xac>
    80001ed0:	4901                	li	s2,0
    exit(-1);
    80001ed2:	557d                	li	a0,-1
    80001ed4:	00000097          	auipc	ra,0x0
    80001ed8:	90c080e7          	jalr	-1780(ra) # 800017e0 <exit>
  if(which_dev == 2)
    80001edc:	4789                	li	a5,2
    80001ede:	04f90f63          	beq	s2,a5,80001f3c <usertrap+0x106>
  usertrapret();
    80001ee2:	00000097          	auipc	ra,0x0
    80001ee6:	dd6080e7          	jalr	-554(ra) # 80001cb8 <usertrapret>
}
    80001eea:	60e2                	ld	ra,24(sp)
    80001eec:	6442                	ld	s0,16(sp)
    80001eee:	64a2                	ld	s1,8(sp)
    80001ef0:	6902                	ld	s2,0(sp)
    80001ef2:	6105                	addi	sp,sp,32
    80001ef4:	8082                	ret
      exit(-1);
    80001ef6:	557d                	li	a0,-1
    80001ef8:	00000097          	auipc	ra,0x0
    80001efc:	8e8080e7          	jalr	-1816(ra) # 800017e0 <exit>
    80001f00:	b765                	j	80001ea8 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f02:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001f06:	5890                	lw	a2,48(s1)
    80001f08:	00006517          	auipc	a0,0x6
    80001f0c:	41850513          	addi	a0,a0,1048 # 80008320 <states.1727+0x78>
    80001f10:	00004097          	auipc	ra,0x4
    80001f14:	fac080e7          	jalr	-84(ra) # 80005ebc <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f18:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f1c:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001f20:	00006517          	auipc	a0,0x6
    80001f24:	43050513          	addi	a0,a0,1072 # 80008350 <states.1727+0xa8>
    80001f28:	00004097          	auipc	ra,0x4
    80001f2c:	f94080e7          	jalr	-108(ra) # 80005ebc <printf>
    setkilled(p);
    80001f30:	8526                	mv	a0,s1
    80001f32:	00000097          	auipc	ra,0x0
    80001f36:	9f6080e7          	jalr	-1546(ra) # 80001928 <setkilled>
    80001f3a:	b769                	j	80001ec4 <usertrap+0x8e>
    yield();
    80001f3c:	fffff097          	auipc	ra,0xfffff
    80001f40:	734080e7          	jalr	1844(ra) # 80001670 <yield>
    80001f44:	bf79                	j	80001ee2 <usertrap+0xac>

0000000080001f46 <kerneltrap>:
{
    80001f46:	7179                	addi	sp,sp,-48
    80001f48:	f406                	sd	ra,40(sp)
    80001f4a:	f022                	sd	s0,32(sp)
    80001f4c:	ec26                	sd	s1,24(sp)
    80001f4e:	e84a                	sd	s2,16(sp)
    80001f50:	e44e                	sd	s3,8(sp)
    80001f52:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f54:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f58:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f5c:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001f60:	1004f793          	andi	a5,s1,256
    80001f64:	cb85                	beqz	a5,80001f94 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f66:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001f6a:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001f6c:	ef85                	bnez	a5,80001fa4 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001f6e:	00000097          	auipc	ra,0x0
    80001f72:	e26080e7          	jalr	-474(ra) # 80001d94 <devintr>
    80001f76:	cd1d                	beqz	a0,80001fb4 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f78:	4789                	li	a5,2
    80001f7a:	06f50a63          	beq	a0,a5,80001fee <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001f7e:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f82:	10049073          	csrw	sstatus,s1
}
    80001f86:	70a2                	ld	ra,40(sp)
    80001f88:	7402                	ld	s0,32(sp)
    80001f8a:	64e2                	ld	s1,24(sp)
    80001f8c:	6942                	ld	s2,16(sp)
    80001f8e:	69a2                	ld	s3,8(sp)
    80001f90:	6145                	addi	sp,sp,48
    80001f92:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001f94:	00006517          	auipc	a0,0x6
    80001f98:	3dc50513          	addi	a0,a0,988 # 80008370 <states.1727+0xc8>
    80001f9c:	00004097          	auipc	ra,0x4
    80001fa0:	ed6080e7          	jalr	-298(ra) # 80005e72 <panic>
    panic("kerneltrap: interrupts enabled");
    80001fa4:	00006517          	auipc	a0,0x6
    80001fa8:	3f450513          	addi	a0,a0,1012 # 80008398 <states.1727+0xf0>
    80001fac:	00004097          	auipc	ra,0x4
    80001fb0:	ec6080e7          	jalr	-314(ra) # 80005e72 <panic>
    printf("scause %p\n", scause);
    80001fb4:	85ce                	mv	a1,s3
    80001fb6:	00006517          	auipc	a0,0x6
    80001fba:	40250513          	addi	a0,a0,1026 # 800083b8 <states.1727+0x110>
    80001fbe:	00004097          	auipc	ra,0x4
    80001fc2:	efe080e7          	jalr	-258(ra) # 80005ebc <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001fc6:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001fca:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001fce:	00006517          	auipc	a0,0x6
    80001fd2:	3fa50513          	addi	a0,a0,1018 # 800083c8 <states.1727+0x120>
    80001fd6:	00004097          	auipc	ra,0x4
    80001fda:	ee6080e7          	jalr	-282(ra) # 80005ebc <printf>
    panic("kerneltrap");
    80001fde:	00006517          	auipc	a0,0x6
    80001fe2:	40250513          	addi	a0,a0,1026 # 800083e0 <states.1727+0x138>
    80001fe6:	00004097          	auipc	ra,0x4
    80001fea:	e8c080e7          	jalr	-372(ra) # 80005e72 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001fee:	fffff097          	auipc	ra,0xfffff
    80001ff2:	f52080e7          	jalr	-174(ra) # 80000f40 <myproc>
    80001ff6:	d541                	beqz	a0,80001f7e <kerneltrap+0x38>
    80001ff8:	fffff097          	auipc	ra,0xfffff
    80001ffc:	f48080e7          	jalr	-184(ra) # 80000f40 <myproc>
    80002000:	4d18                	lw	a4,24(a0)
    80002002:	4791                	li	a5,4
    80002004:	f6f71de3          	bne	a4,a5,80001f7e <kerneltrap+0x38>
    yield();
    80002008:	fffff097          	auipc	ra,0xfffff
    8000200c:	668080e7          	jalr	1640(ra) # 80001670 <yield>
    80002010:	b7bd                	j	80001f7e <kerneltrap+0x38>

0000000080002012 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002012:	1101                	addi	sp,sp,-32
    80002014:	ec06                	sd	ra,24(sp)
    80002016:	e822                	sd	s0,16(sp)
    80002018:	e426                	sd	s1,8(sp)
    8000201a:	1000                	addi	s0,sp,32
    8000201c:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    8000201e:	fffff097          	auipc	ra,0xfffff
    80002022:	f22080e7          	jalr	-222(ra) # 80000f40 <myproc>
  switch (n) {
    80002026:	4795                	li	a5,5
    80002028:	0497e163          	bltu	a5,s1,8000206a <argraw+0x58>
    8000202c:	048a                	slli	s1,s1,0x2
    8000202e:	00006717          	auipc	a4,0x6
    80002032:	3ea70713          	addi	a4,a4,1002 # 80008418 <states.1727+0x170>
    80002036:	94ba                	add	s1,s1,a4
    80002038:	409c                	lw	a5,0(s1)
    8000203a:	97ba                	add	a5,a5,a4
    8000203c:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    8000203e:	6d3c                	ld	a5,88(a0)
    80002040:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002042:	60e2                	ld	ra,24(sp)
    80002044:	6442                	ld	s0,16(sp)
    80002046:	64a2                	ld	s1,8(sp)
    80002048:	6105                	addi	sp,sp,32
    8000204a:	8082                	ret
    return p->trapframe->a1;
    8000204c:	6d3c                	ld	a5,88(a0)
    8000204e:	7fa8                	ld	a0,120(a5)
    80002050:	bfcd                	j	80002042 <argraw+0x30>
    return p->trapframe->a2;
    80002052:	6d3c                	ld	a5,88(a0)
    80002054:	63c8                	ld	a0,128(a5)
    80002056:	b7f5                	j	80002042 <argraw+0x30>
    return p->trapframe->a3;
    80002058:	6d3c                	ld	a5,88(a0)
    8000205a:	67c8                	ld	a0,136(a5)
    8000205c:	b7dd                	j	80002042 <argraw+0x30>
    return p->trapframe->a4;
    8000205e:	6d3c                	ld	a5,88(a0)
    80002060:	6bc8                	ld	a0,144(a5)
    80002062:	b7c5                	j	80002042 <argraw+0x30>
    return p->trapframe->a5;
    80002064:	6d3c                	ld	a5,88(a0)
    80002066:	6fc8                	ld	a0,152(a5)
    80002068:	bfe9                	j	80002042 <argraw+0x30>
  panic("argraw");
    8000206a:	00006517          	auipc	a0,0x6
    8000206e:	38650513          	addi	a0,a0,902 # 800083f0 <states.1727+0x148>
    80002072:	00004097          	auipc	ra,0x4
    80002076:	e00080e7          	jalr	-512(ra) # 80005e72 <panic>

000000008000207a <fetchaddr>:
{
    8000207a:	1101                	addi	sp,sp,-32
    8000207c:	ec06                	sd	ra,24(sp)
    8000207e:	e822                	sd	s0,16(sp)
    80002080:	e426                	sd	s1,8(sp)
    80002082:	e04a                	sd	s2,0(sp)
    80002084:	1000                	addi	s0,sp,32
    80002086:	84aa                	mv	s1,a0
    80002088:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000208a:	fffff097          	auipc	ra,0xfffff
    8000208e:	eb6080e7          	jalr	-330(ra) # 80000f40 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002092:	653c                	ld	a5,72(a0)
    80002094:	02f4f863          	bgeu	s1,a5,800020c4 <fetchaddr+0x4a>
    80002098:	00848713          	addi	a4,s1,8
    8000209c:	02e7e663          	bltu	a5,a4,800020c8 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    800020a0:	46a1                	li	a3,8
    800020a2:	8626                	mv	a2,s1
    800020a4:	85ca                	mv	a1,s2
    800020a6:	6928                	ld	a0,80(a0)
    800020a8:	fffff097          	auipc	ra,0xfffff
    800020ac:	afa080e7          	jalr	-1286(ra) # 80000ba2 <copyin>
    800020b0:	00a03533          	snez	a0,a0
    800020b4:	40a00533          	neg	a0,a0
}
    800020b8:	60e2                	ld	ra,24(sp)
    800020ba:	6442                	ld	s0,16(sp)
    800020bc:	64a2                	ld	s1,8(sp)
    800020be:	6902                	ld	s2,0(sp)
    800020c0:	6105                	addi	sp,sp,32
    800020c2:	8082                	ret
    return -1;
    800020c4:	557d                	li	a0,-1
    800020c6:	bfcd                	j	800020b8 <fetchaddr+0x3e>
    800020c8:	557d                	li	a0,-1
    800020ca:	b7fd                	j	800020b8 <fetchaddr+0x3e>

00000000800020cc <fetchstr>:
{
    800020cc:	7179                	addi	sp,sp,-48
    800020ce:	f406                	sd	ra,40(sp)
    800020d0:	f022                	sd	s0,32(sp)
    800020d2:	ec26                	sd	s1,24(sp)
    800020d4:	e84a                	sd	s2,16(sp)
    800020d6:	e44e                	sd	s3,8(sp)
    800020d8:	1800                	addi	s0,sp,48
    800020da:	892a                	mv	s2,a0
    800020dc:	84ae                	mv	s1,a1
    800020de:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    800020e0:	fffff097          	auipc	ra,0xfffff
    800020e4:	e60080e7          	jalr	-416(ra) # 80000f40 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    800020e8:	86ce                	mv	a3,s3
    800020ea:	864a                	mv	a2,s2
    800020ec:	85a6                	mv	a1,s1
    800020ee:	6928                	ld	a0,80(a0)
    800020f0:	fffff097          	auipc	ra,0xfffff
    800020f4:	b3e080e7          	jalr	-1218(ra) # 80000c2e <copyinstr>
    800020f8:	00054e63          	bltz	a0,80002114 <fetchstr+0x48>
  return strlen(buf);
    800020fc:	8526                	mv	a0,s1
    800020fe:	ffffe097          	auipc	ra,0xffffe
    80002102:	1fe080e7          	jalr	510(ra) # 800002fc <strlen>
}
    80002106:	70a2                	ld	ra,40(sp)
    80002108:	7402                	ld	s0,32(sp)
    8000210a:	64e2                	ld	s1,24(sp)
    8000210c:	6942                	ld	s2,16(sp)
    8000210e:	69a2                	ld	s3,8(sp)
    80002110:	6145                	addi	sp,sp,48
    80002112:	8082                	ret
    return -1;
    80002114:	557d                	li	a0,-1
    80002116:	bfc5                	j	80002106 <fetchstr+0x3a>

0000000080002118 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80002118:	1101                	addi	sp,sp,-32
    8000211a:	ec06                	sd	ra,24(sp)
    8000211c:	e822                	sd	s0,16(sp)
    8000211e:	e426                	sd	s1,8(sp)
    80002120:	1000                	addi	s0,sp,32
    80002122:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002124:	00000097          	auipc	ra,0x0
    80002128:	eee080e7          	jalr	-274(ra) # 80002012 <argraw>
    8000212c:	c088                	sw	a0,0(s1)
}
    8000212e:	60e2                	ld	ra,24(sp)
    80002130:	6442                	ld	s0,16(sp)
    80002132:	64a2                	ld	s1,8(sp)
    80002134:	6105                	addi	sp,sp,32
    80002136:	8082                	ret

0000000080002138 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80002138:	1101                	addi	sp,sp,-32
    8000213a:	ec06                	sd	ra,24(sp)
    8000213c:	e822                	sd	s0,16(sp)
    8000213e:	e426                	sd	s1,8(sp)
    80002140:	1000                	addi	s0,sp,32
    80002142:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002144:	00000097          	auipc	ra,0x0
    80002148:	ece080e7          	jalr	-306(ra) # 80002012 <argraw>
    8000214c:	e088                	sd	a0,0(s1)
}
    8000214e:	60e2                	ld	ra,24(sp)
    80002150:	6442                	ld	s0,16(sp)
    80002152:	64a2                	ld	s1,8(sp)
    80002154:	6105                	addi	sp,sp,32
    80002156:	8082                	ret

0000000080002158 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002158:	7179                	addi	sp,sp,-48
    8000215a:	f406                	sd	ra,40(sp)
    8000215c:	f022                	sd	s0,32(sp)
    8000215e:	ec26                	sd	s1,24(sp)
    80002160:	e84a                	sd	s2,16(sp)
    80002162:	1800                	addi	s0,sp,48
    80002164:	84ae                	mv	s1,a1
    80002166:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002168:	fd840593          	addi	a1,s0,-40
    8000216c:	00000097          	auipc	ra,0x0
    80002170:	fcc080e7          	jalr	-52(ra) # 80002138 <argaddr>
  return fetchstr(addr, buf, max);
    80002174:	864a                	mv	a2,s2
    80002176:	85a6                	mv	a1,s1
    80002178:	fd843503          	ld	a0,-40(s0)
    8000217c:	00000097          	auipc	ra,0x0
    80002180:	f50080e7          	jalr	-176(ra) # 800020cc <fetchstr>
}
    80002184:	70a2                	ld	ra,40(sp)
    80002186:	7402                	ld	s0,32(sp)
    80002188:	64e2                	ld	s1,24(sp)
    8000218a:	6942                	ld	s2,16(sp)
    8000218c:	6145                	addi	sp,sp,48
    8000218e:	8082                	ret

0000000080002190 <syscall>:



void
syscall(void)
{
    80002190:	1101                	addi	sp,sp,-32
    80002192:	ec06                	sd	ra,24(sp)
    80002194:	e822                	sd	s0,16(sp)
    80002196:	e426                	sd	s1,8(sp)
    80002198:	e04a                	sd	s2,0(sp)
    8000219a:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    8000219c:	fffff097          	auipc	ra,0xfffff
    800021a0:	da4080e7          	jalr	-604(ra) # 80000f40 <myproc>
    800021a4:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800021a6:	05853903          	ld	s2,88(a0)
    800021aa:	0a893783          	ld	a5,168(s2)
    800021ae:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800021b2:	37fd                	addiw	a5,a5,-1
    800021b4:	4775                	li	a4,29
    800021b6:	00f76f63          	bltu	a4,a5,800021d4 <syscall+0x44>
    800021ba:	00369713          	slli	a4,a3,0x3
    800021be:	00006797          	auipc	a5,0x6
    800021c2:	27278793          	addi	a5,a5,626 # 80008430 <syscalls>
    800021c6:	97ba                	add	a5,a5,a4
    800021c8:	639c                	ld	a5,0(a5)
    800021ca:	c789                	beqz	a5,800021d4 <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    800021cc:	9782                	jalr	a5
    800021ce:	06a93823          	sd	a0,112(s2)
    800021d2:	a839                	j	800021f0 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800021d4:	15848613          	addi	a2,s1,344
    800021d8:	588c                	lw	a1,48(s1)
    800021da:	00006517          	auipc	a0,0x6
    800021de:	21e50513          	addi	a0,a0,542 # 800083f8 <states.1727+0x150>
    800021e2:	00004097          	auipc	ra,0x4
    800021e6:	cda080e7          	jalr	-806(ra) # 80005ebc <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800021ea:	6cbc                	ld	a5,88(s1)
    800021ec:	577d                	li	a4,-1
    800021ee:	fbb8                	sd	a4,112(a5)
  }
}
    800021f0:	60e2                	ld	ra,24(sp)
    800021f2:	6442                	ld	s0,16(sp)
    800021f4:	64a2                	ld	s1,8(sp)
    800021f6:	6902                	ld	s2,0(sp)
    800021f8:	6105                	addi	sp,sp,32
    800021fa:	8082                	ret

00000000800021fc <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800021fc:	1101                	addi	sp,sp,-32
    800021fe:	ec06                	sd	ra,24(sp)
    80002200:	e822                	sd	s0,16(sp)
    80002202:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002204:	fec40593          	addi	a1,s0,-20
    80002208:	4501                	li	a0,0
    8000220a:	00000097          	auipc	ra,0x0
    8000220e:	f0e080e7          	jalr	-242(ra) # 80002118 <argint>
  exit(n);
    80002212:	fec42503          	lw	a0,-20(s0)
    80002216:	fffff097          	auipc	ra,0xfffff
    8000221a:	5ca080e7          	jalr	1482(ra) # 800017e0 <exit>
  return 0;  // not reached
}
    8000221e:	4501                	li	a0,0
    80002220:	60e2                	ld	ra,24(sp)
    80002222:	6442                	ld	s0,16(sp)
    80002224:	6105                	addi	sp,sp,32
    80002226:	8082                	ret

0000000080002228 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002228:	1141                	addi	sp,sp,-16
    8000222a:	e406                	sd	ra,8(sp)
    8000222c:	e022                	sd	s0,0(sp)
    8000222e:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002230:	fffff097          	auipc	ra,0xfffff
    80002234:	d10080e7          	jalr	-752(ra) # 80000f40 <myproc>
}
    80002238:	5908                	lw	a0,48(a0)
    8000223a:	60a2                	ld	ra,8(sp)
    8000223c:	6402                	ld	s0,0(sp)
    8000223e:	0141                	addi	sp,sp,16
    80002240:	8082                	ret

0000000080002242 <sys_fork>:

uint64
sys_fork(void)
{
    80002242:	1141                	addi	sp,sp,-16
    80002244:	e406                	sd	ra,8(sp)
    80002246:	e022                	sd	s0,0(sp)
    80002248:	0800                	addi	s0,sp,16
  return fork();
    8000224a:	fffff097          	auipc	ra,0xfffff
    8000224e:	174080e7          	jalr	372(ra) # 800013be <fork>
}
    80002252:	60a2                	ld	ra,8(sp)
    80002254:	6402                	ld	s0,0(sp)
    80002256:	0141                	addi	sp,sp,16
    80002258:	8082                	ret

000000008000225a <sys_wait>:

uint64
sys_wait(void)
{
    8000225a:	1101                	addi	sp,sp,-32
    8000225c:	ec06                	sd	ra,24(sp)
    8000225e:	e822                	sd	s0,16(sp)
    80002260:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002262:	fe840593          	addi	a1,s0,-24
    80002266:	4501                	li	a0,0
    80002268:	00000097          	auipc	ra,0x0
    8000226c:	ed0080e7          	jalr	-304(ra) # 80002138 <argaddr>
  return wait(p);
    80002270:	fe843503          	ld	a0,-24(s0)
    80002274:	fffff097          	auipc	ra,0xfffff
    80002278:	712080e7          	jalr	1810(ra) # 80001986 <wait>
}
    8000227c:	60e2                	ld	ra,24(sp)
    8000227e:	6442                	ld	s0,16(sp)
    80002280:	6105                	addi	sp,sp,32
    80002282:	8082                	ret

0000000080002284 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002284:	7179                	addi	sp,sp,-48
    80002286:	f406                	sd	ra,40(sp)
    80002288:	f022                	sd	s0,32(sp)
    8000228a:	ec26                	sd	s1,24(sp)
    8000228c:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    8000228e:	fdc40593          	addi	a1,s0,-36
    80002292:	4501                	li	a0,0
    80002294:	00000097          	auipc	ra,0x0
    80002298:	e84080e7          	jalr	-380(ra) # 80002118 <argint>
  addr = myproc()->sz;
    8000229c:	fffff097          	auipc	ra,0xfffff
    800022a0:	ca4080e7          	jalr	-860(ra) # 80000f40 <myproc>
    800022a4:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    800022a6:	fdc42503          	lw	a0,-36(s0)
    800022aa:	fffff097          	auipc	ra,0xfffff
    800022ae:	0b8080e7          	jalr	184(ra) # 80001362 <growproc>
    800022b2:	00054863          	bltz	a0,800022c2 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    800022b6:	8526                	mv	a0,s1
    800022b8:	70a2                	ld	ra,40(sp)
    800022ba:	7402                	ld	s0,32(sp)
    800022bc:	64e2                	ld	s1,24(sp)
    800022be:	6145                	addi	sp,sp,48
    800022c0:	8082                	ret
    return -1;
    800022c2:	54fd                	li	s1,-1
    800022c4:	bfcd                	j	800022b6 <sys_sbrk+0x32>

00000000800022c6 <sys_sleep>:

uint64
sys_sleep(void)
{
    800022c6:	7139                	addi	sp,sp,-64
    800022c8:	fc06                	sd	ra,56(sp)
    800022ca:	f822                	sd	s0,48(sp)
    800022cc:	f426                	sd	s1,40(sp)
    800022ce:	f04a                	sd	s2,32(sp)
    800022d0:	ec4e                	sd	s3,24(sp)
    800022d2:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;


  argint(0, &n);
    800022d4:	fcc40593          	addi	a1,s0,-52
    800022d8:	4501                	li	a0,0
    800022da:	00000097          	auipc	ra,0x0
    800022de:	e3e080e7          	jalr	-450(ra) # 80002118 <argint>
  acquire(&tickslock);
    800022e2:	0000c517          	auipc	a0,0xc
    800022e6:	6fe50513          	addi	a0,a0,1790 # 8000e9e0 <tickslock>
    800022ea:	00004097          	auipc	ra,0x4
    800022ee:	0d2080e7          	jalr	210(ra) # 800063bc <acquire>
  ticks0 = ticks;
    800022f2:	00006917          	auipc	s2,0x6
    800022f6:	68692903          	lw	s2,1670(s2) # 80008978 <ticks>
  while(ticks - ticks0 < n){
    800022fa:	fcc42783          	lw	a5,-52(s0)
    800022fe:	cf9d                	beqz	a5,8000233c <sys_sleep+0x76>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002300:	0000c997          	auipc	s3,0xc
    80002304:	6e098993          	addi	s3,s3,1760 # 8000e9e0 <tickslock>
    80002308:	00006497          	auipc	s1,0x6
    8000230c:	67048493          	addi	s1,s1,1648 # 80008978 <ticks>
    if(killed(myproc())){
    80002310:	fffff097          	auipc	ra,0xfffff
    80002314:	c30080e7          	jalr	-976(ra) # 80000f40 <myproc>
    80002318:	fffff097          	auipc	ra,0xfffff
    8000231c:	63c080e7          	jalr	1596(ra) # 80001954 <killed>
    80002320:	ed15                	bnez	a0,8000235c <sys_sleep+0x96>
    sleep(&ticks, &tickslock);
    80002322:	85ce                	mv	a1,s3
    80002324:	8526                	mv	a0,s1
    80002326:	fffff097          	auipc	ra,0xfffff
    8000232a:	386080e7          	jalr	902(ra) # 800016ac <sleep>
  while(ticks - ticks0 < n){
    8000232e:	409c                	lw	a5,0(s1)
    80002330:	412787bb          	subw	a5,a5,s2
    80002334:	fcc42703          	lw	a4,-52(s0)
    80002338:	fce7ece3          	bltu	a5,a4,80002310 <sys_sleep+0x4a>
  }
  release(&tickslock);
    8000233c:	0000c517          	auipc	a0,0xc
    80002340:	6a450513          	addi	a0,a0,1700 # 8000e9e0 <tickslock>
    80002344:	00004097          	auipc	ra,0x4
    80002348:	12c080e7          	jalr	300(ra) # 80006470 <release>
  return 0;
    8000234c:	4501                	li	a0,0
}
    8000234e:	70e2                	ld	ra,56(sp)
    80002350:	7442                	ld	s0,48(sp)
    80002352:	74a2                	ld	s1,40(sp)
    80002354:	7902                	ld	s2,32(sp)
    80002356:	69e2                	ld	s3,24(sp)
    80002358:	6121                	addi	sp,sp,64
    8000235a:	8082                	ret
      release(&tickslock);
    8000235c:	0000c517          	auipc	a0,0xc
    80002360:	68450513          	addi	a0,a0,1668 # 8000e9e0 <tickslock>
    80002364:	00004097          	auipc	ra,0x4
    80002368:	10c080e7          	jalr	268(ra) # 80006470 <release>
      return -1;
    8000236c:	557d                	li	a0,-1
    8000236e:	b7c5                	j	8000234e <sys_sleep+0x88>

0000000080002370 <sys_pgaccess>:


#ifdef LAB_PGTBL
int
sys_pgaccess(void)
{
    80002370:	7139                	addi	sp,sp,-64
    80002372:	fc06                	sd	ra,56(sp)
    80002374:	f822                	sd	s0,48(sp)
    80002376:	f426                	sd	s1,40(sp)
    80002378:	0080                	addi	s0,sp,64
  // lab pgtbl: your code here.

  struct proc* p = myproc();
    8000237a:	fffff097          	auipc	ra,0xfffff
    8000237e:	bc6080e7          	jalr	-1082(ra) # 80000f40 <myproc>
    80002382:	84aa                	mv	s1,a0
  uint64 buf_addr;
  int num;
  uint64 bits;

//得到用户空间的参数
  argaddr(0, &buf_addr);
    80002384:	fd840593          	addi	a1,s0,-40
    80002388:	4501                	li	a0,0
    8000238a:	00000097          	auipc	ra,0x0
    8000238e:	dae080e7          	jalr	-594(ra) # 80002138 <argaddr>
  argint(1, &num);
    80002392:	fd440593          	addi	a1,s0,-44
    80002396:	4505                	li	a0,1
    80002398:	00000097          	auipc	ra,0x0
    8000239c:	d80080e7          	jalr	-640(ra) # 80002118 <argint>
  argaddr(2, &bits);
    800023a0:	fc840593          	addi	a1,s0,-56
    800023a4:	4509                	li	a0,2
    800023a6:	00000097          	auipc	ra,0x0
    800023aa:	d92080e7          	jalr	-622(ra) # 80002138 <argaddr>
  
  //遍历指定虚拟地址对应的页表; 填充bits，1表示对应页是access
  int third = PX(0, buf_addr);
    800023ae:	fd843703          	ld	a4,-40(s0)
  int second = PX(1, buf_addr);
  int first = PX(2, buf_addr);
    800023b2:	01e75793          	srli	a5,a4,0x1e

  pte_t pte  = p->pagetable[first];
    800023b6:	1ff7f793          	andi	a5,a5,511
    800023ba:	68b4                	ld	a3,80(s1)
    800023bc:	078e                	slli	a5,a5,0x3
    800023be:	97b6                	add	a5,a5,a3
    800023c0:	639c                	ld	a5,0(a5)
  uint64 idx = 0;
    800023c2:	fc043023          	sd	zero,-64(s0)
  
  if(pte & PTE_V){
    800023c6:	0017f693          	andi	a3,a5,1
    800023ca:	c6bd                	beqz	a3,80002438 <sys_pgaccess+0xc8>
  int second = PX(1, buf_addr);
    800023cc:	01575693          	srli	a3,a4,0x15
    uint64 child = PTE2PA(pte);//二级页表物理地址
    pte_t pte1 = ((pagetable_t)child)[second];
    800023d0:	1ff6f693          	andi	a3,a3,511
    uint64 child = PTE2PA(pte);//二级页表物理地址
    800023d4:	83a9                	srli	a5,a5,0xa
    800023d6:	07b2                	slli	a5,a5,0xc
    pte_t pte1 = ((pagetable_t)child)[second];
    800023d8:	068e                	slli	a3,a3,0x3
    800023da:	97b6                	add	a5,a5,a3
    800023dc:	639c                	ld	a5,0(a5)
    if(pte1 & PTE_V){
    800023de:	0017f693          	andi	a3,a5,1
    800023e2:	cab9                	beqz	a3,80002438 <sys_pgaccess+0xc8>
      uint64 child1 = PTE2PA(pte1);//三级页表物理地址
    800023e4:	83a9                	srli	a5,a5,0xa
    800023e6:	00c79693          	slli	a3,a5,0xc
      for(int i = 0; i < num; i++){
    800023ea:	fd442783          	lw	a5,-44(s0)
    800023ee:	04f05563          	blez	a5,80002438 <sys_pgaccess+0xc8>
  int third = PX(0, buf_addr);
    800023f2:	00c75793          	srli	a5,a4,0xc
    800023f6:	1ff7f793          	andi	a5,a5,511
    800023fa:	078e                	slli	a5,a5,0x3
    800023fc:	97b6                	add	a5,a5,a3
      for(int i = 0; i < num; i++){
    800023fe:	4701                	li	a4,0
        pte_t* pte2 = &((pagetable_t)child1)[third + i];
        if(pte2 && (*pte2 & PTE_V) && (*pte2 & PTE_A)){
    80002400:	04100593          	li	a1,65
          idx = idx | (1 << i);
    80002404:	4505                	li	a0,1
    80002406:	a039                	j	80002414 <sys_pgaccess+0xa4>
      for(int i = 0; i < num; i++){
    80002408:	2705                	addiw	a4,a4,1
    8000240a:	07a1                	addi	a5,a5,8
    8000240c:	fd442683          	lw	a3,-44(s0)
    80002410:	02d75463          	bge	a4,a3,80002438 <sys_pgaccess+0xc8>
        if(pte2 && (*pte2 & PTE_V) && (*pte2 & PTE_A)){
    80002414:	dbf5                	beqz	a5,80002408 <sys_pgaccess+0x98>
    80002416:	6394                	ld	a3,0(a5)
    80002418:	0416f693          	andi	a3,a3,65
    8000241c:	feb696e3          	bne	a3,a1,80002408 <sys_pgaccess+0x98>
          idx = idx | (1 << i);
    80002420:	00e516bb          	sllw	a3,a0,a4
    80002424:	fc043603          	ld	a2,-64(s0)
    80002428:	8ed1                	or	a3,a3,a2
    8000242a:	fcd43023          	sd	a3,-64(s0)
          *pte2 &= ~PTE_A;
    8000242e:	6394                	ld	a3,0(a5)
    80002430:	fbf6f693          	andi	a3,a3,-65
    80002434:	e394                	sd	a3,0(a5)
    80002436:	bfc9                	j	80002408 <sys_pgaccess+0x98>
        }
      }
    }
  }

  copyout(p->pagetable, bits, (char*)(&idx), sizeof(idx));
    80002438:	46a1                	li	a3,8
    8000243a:	fc040613          	addi	a2,s0,-64
    8000243e:	fc843583          	ld	a1,-56(s0)
    80002442:	68a8                	ld	a0,80(s1)
    80002444:	ffffe097          	auipc	ra,0xffffe
    80002448:	6d2080e7          	jalr	1746(ra) # 80000b16 <copyout>

  // // 将检测结果写入用户栈
  // copyout(p->pagetable, access_mask, (char*)&mask, sizeof(mask));
  //----------------------------------
  return 0;
}
    8000244c:	4501                	li	a0,0
    8000244e:	70e2                	ld	ra,56(sp)
    80002450:	7442                	ld	s0,48(sp)
    80002452:	74a2                	ld	s1,40(sp)
    80002454:	6121                	addi	sp,sp,64
    80002456:	8082                	ret

0000000080002458 <sys_kill>:
#endif

uint64
sys_kill(void)
{
    80002458:	1101                	addi	sp,sp,-32
    8000245a:	ec06                	sd	ra,24(sp)
    8000245c:	e822                	sd	s0,16(sp)
    8000245e:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002460:	fec40593          	addi	a1,s0,-20
    80002464:	4501                	li	a0,0
    80002466:	00000097          	auipc	ra,0x0
    8000246a:	cb2080e7          	jalr	-846(ra) # 80002118 <argint>
  return kill(pid);
    8000246e:	fec42503          	lw	a0,-20(s0)
    80002472:	fffff097          	auipc	ra,0xfffff
    80002476:	444080e7          	jalr	1092(ra) # 800018b6 <kill>
}
    8000247a:	60e2                	ld	ra,24(sp)
    8000247c:	6442                	ld	s0,16(sp)
    8000247e:	6105                	addi	sp,sp,32
    80002480:	8082                	ret

0000000080002482 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002482:	1101                	addi	sp,sp,-32
    80002484:	ec06                	sd	ra,24(sp)
    80002486:	e822                	sd	s0,16(sp)
    80002488:	e426                	sd	s1,8(sp)
    8000248a:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    8000248c:	0000c517          	auipc	a0,0xc
    80002490:	55450513          	addi	a0,a0,1364 # 8000e9e0 <tickslock>
    80002494:	00004097          	auipc	ra,0x4
    80002498:	f28080e7          	jalr	-216(ra) # 800063bc <acquire>
  xticks = ticks;
    8000249c:	00006497          	auipc	s1,0x6
    800024a0:	4dc4a483          	lw	s1,1244(s1) # 80008978 <ticks>
  release(&tickslock);
    800024a4:	0000c517          	auipc	a0,0xc
    800024a8:	53c50513          	addi	a0,a0,1340 # 8000e9e0 <tickslock>
    800024ac:	00004097          	auipc	ra,0x4
    800024b0:	fc4080e7          	jalr	-60(ra) # 80006470 <release>
  return xticks;
}
    800024b4:	02049513          	slli	a0,s1,0x20
    800024b8:	9101                	srli	a0,a0,0x20
    800024ba:	60e2                	ld	ra,24(sp)
    800024bc:	6442                	ld	s0,16(sp)
    800024be:	64a2                	ld	s1,8(sp)
    800024c0:	6105                	addi	sp,sp,32
    800024c2:	8082                	ret

00000000800024c4 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800024c4:	7179                	addi	sp,sp,-48
    800024c6:	f406                	sd	ra,40(sp)
    800024c8:	f022                	sd	s0,32(sp)
    800024ca:	ec26                	sd	s1,24(sp)
    800024cc:	e84a                	sd	s2,16(sp)
    800024ce:	e44e                	sd	s3,8(sp)
    800024d0:	e052                	sd	s4,0(sp)
    800024d2:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800024d4:	00006597          	auipc	a1,0x6
    800024d8:	05458593          	addi	a1,a1,84 # 80008528 <syscalls+0xf8>
    800024dc:	0000c517          	auipc	a0,0xc
    800024e0:	51c50513          	addi	a0,a0,1308 # 8000e9f8 <bcache>
    800024e4:	00004097          	auipc	ra,0x4
    800024e8:	e48080e7          	jalr	-440(ra) # 8000632c <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800024ec:	00014797          	auipc	a5,0x14
    800024f0:	50c78793          	addi	a5,a5,1292 # 800169f8 <bcache+0x8000>
    800024f4:	00014717          	auipc	a4,0x14
    800024f8:	76c70713          	addi	a4,a4,1900 # 80016c60 <bcache+0x8268>
    800024fc:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002500:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002504:	0000c497          	auipc	s1,0xc
    80002508:	50c48493          	addi	s1,s1,1292 # 8000ea10 <bcache+0x18>
    b->next = bcache.head.next;
    8000250c:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000250e:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002510:	00006a17          	auipc	s4,0x6
    80002514:	020a0a13          	addi	s4,s4,32 # 80008530 <syscalls+0x100>
    b->next = bcache.head.next;
    80002518:	2b893783          	ld	a5,696(s2)
    8000251c:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000251e:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002522:	85d2                	mv	a1,s4
    80002524:	01048513          	addi	a0,s1,16
    80002528:	00001097          	auipc	ra,0x1
    8000252c:	4c4080e7          	jalr	1220(ra) # 800039ec <initsleeplock>
    bcache.head.next->prev = b;
    80002530:	2b893783          	ld	a5,696(s2)
    80002534:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002536:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000253a:	45848493          	addi	s1,s1,1112
    8000253e:	fd349de3          	bne	s1,s3,80002518 <binit+0x54>
  }
}
    80002542:	70a2                	ld	ra,40(sp)
    80002544:	7402                	ld	s0,32(sp)
    80002546:	64e2                	ld	s1,24(sp)
    80002548:	6942                	ld	s2,16(sp)
    8000254a:	69a2                	ld	s3,8(sp)
    8000254c:	6a02                	ld	s4,0(sp)
    8000254e:	6145                	addi	sp,sp,48
    80002550:	8082                	ret

0000000080002552 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002552:	7179                	addi	sp,sp,-48
    80002554:	f406                	sd	ra,40(sp)
    80002556:	f022                	sd	s0,32(sp)
    80002558:	ec26                	sd	s1,24(sp)
    8000255a:	e84a                	sd	s2,16(sp)
    8000255c:	e44e                	sd	s3,8(sp)
    8000255e:	1800                	addi	s0,sp,48
    80002560:	89aa                	mv	s3,a0
    80002562:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    80002564:	0000c517          	auipc	a0,0xc
    80002568:	49450513          	addi	a0,a0,1172 # 8000e9f8 <bcache>
    8000256c:	00004097          	auipc	ra,0x4
    80002570:	e50080e7          	jalr	-432(ra) # 800063bc <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002574:	00014497          	auipc	s1,0x14
    80002578:	73c4b483          	ld	s1,1852(s1) # 80016cb0 <bcache+0x82b8>
    8000257c:	00014797          	auipc	a5,0x14
    80002580:	6e478793          	addi	a5,a5,1764 # 80016c60 <bcache+0x8268>
    80002584:	02f48f63          	beq	s1,a5,800025c2 <bread+0x70>
    80002588:	873e                	mv	a4,a5
    8000258a:	a021                	j	80002592 <bread+0x40>
    8000258c:	68a4                	ld	s1,80(s1)
    8000258e:	02e48a63          	beq	s1,a4,800025c2 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002592:	449c                	lw	a5,8(s1)
    80002594:	ff379ce3          	bne	a5,s3,8000258c <bread+0x3a>
    80002598:	44dc                	lw	a5,12(s1)
    8000259a:	ff2799e3          	bne	a5,s2,8000258c <bread+0x3a>
      b->refcnt++;
    8000259e:	40bc                	lw	a5,64(s1)
    800025a0:	2785                	addiw	a5,a5,1
    800025a2:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800025a4:	0000c517          	auipc	a0,0xc
    800025a8:	45450513          	addi	a0,a0,1108 # 8000e9f8 <bcache>
    800025ac:	00004097          	auipc	ra,0x4
    800025b0:	ec4080e7          	jalr	-316(ra) # 80006470 <release>
      acquiresleep(&b->lock);
    800025b4:	01048513          	addi	a0,s1,16
    800025b8:	00001097          	auipc	ra,0x1
    800025bc:	46e080e7          	jalr	1134(ra) # 80003a26 <acquiresleep>
      return b;
    800025c0:	a8b9                	j	8000261e <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800025c2:	00014497          	auipc	s1,0x14
    800025c6:	6e64b483          	ld	s1,1766(s1) # 80016ca8 <bcache+0x82b0>
    800025ca:	00014797          	auipc	a5,0x14
    800025ce:	69678793          	addi	a5,a5,1686 # 80016c60 <bcache+0x8268>
    800025d2:	00f48863          	beq	s1,a5,800025e2 <bread+0x90>
    800025d6:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800025d8:	40bc                	lw	a5,64(s1)
    800025da:	cf81                	beqz	a5,800025f2 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800025dc:	64a4                	ld	s1,72(s1)
    800025de:	fee49de3          	bne	s1,a4,800025d8 <bread+0x86>
  panic("bget: no buffers");
    800025e2:	00006517          	auipc	a0,0x6
    800025e6:	f5650513          	addi	a0,a0,-170 # 80008538 <syscalls+0x108>
    800025ea:	00004097          	auipc	ra,0x4
    800025ee:	888080e7          	jalr	-1912(ra) # 80005e72 <panic>
      b->dev = dev;
    800025f2:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    800025f6:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    800025fa:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800025fe:	4785                	li	a5,1
    80002600:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002602:	0000c517          	auipc	a0,0xc
    80002606:	3f650513          	addi	a0,a0,1014 # 8000e9f8 <bcache>
    8000260a:	00004097          	auipc	ra,0x4
    8000260e:	e66080e7          	jalr	-410(ra) # 80006470 <release>
      acquiresleep(&b->lock);
    80002612:	01048513          	addi	a0,s1,16
    80002616:	00001097          	auipc	ra,0x1
    8000261a:	410080e7          	jalr	1040(ra) # 80003a26 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000261e:	409c                	lw	a5,0(s1)
    80002620:	cb89                	beqz	a5,80002632 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002622:	8526                	mv	a0,s1
    80002624:	70a2                	ld	ra,40(sp)
    80002626:	7402                	ld	s0,32(sp)
    80002628:	64e2                	ld	s1,24(sp)
    8000262a:	6942                	ld	s2,16(sp)
    8000262c:	69a2                	ld	s3,8(sp)
    8000262e:	6145                	addi	sp,sp,48
    80002630:	8082                	ret
    virtio_disk_rw(b, 0);
    80002632:	4581                	li	a1,0
    80002634:	8526                	mv	a0,s1
    80002636:	00003097          	auipc	ra,0x3
    8000263a:	fd2080e7          	jalr	-46(ra) # 80005608 <virtio_disk_rw>
    b->valid = 1;
    8000263e:	4785                	li	a5,1
    80002640:	c09c                	sw	a5,0(s1)
  return b;
    80002642:	b7c5                	j	80002622 <bread+0xd0>

0000000080002644 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002644:	1101                	addi	sp,sp,-32
    80002646:	ec06                	sd	ra,24(sp)
    80002648:	e822                	sd	s0,16(sp)
    8000264a:	e426                	sd	s1,8(sp)
    8000264c:	1000                	addi	s0,sp,32
    8000264e:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002650:	0541                	addi	a0,a0,16
    80002652:	00001097          	auipc	ra,0x1
    80002656:	46e080e7          	jalr	1134(ra) # 80003ac0 <holdingsleep>
    8000265a:	cd01                	beqz	a0,80002672 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000265c:	4585                	li	a1,1
    8000265e:	8526                	mv	a0,s1
    80002660:	00003097          	auipc	ra,0x3
    80002664:	fa8080e7          	jalr	-88(ra) # 80005608 <virtio_disk_rw>
}
    80002668:	60e2                	ld	ra,24(sp)
    8000266a:	6442                	ld	s0,16(sp)
    8000266c:	64a2                	ld	s1,8(sp)
    8000266e:	6105                	addi	sp,sp,32
    80002670:	8082                	ret
    panic("bwrite");
    80002672:	00006517          	auipc	a0,0x6
    80002676:	ede50513          	addi	a0,a0,-290 # 80008550 <syscalls+0x120>
    8000267a:	00003097          	auipc	ra,0x3
    8000267e:	7f8080e7          	jalr	2040(ra) # 80005e72 <panic>

0000000080002682 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002682:	1101                	addi	sp,sp,-32
    80002684:	ec06                	sd	ra,24(sp)
    80002686:	e822                	sd	s0,16(sp)
    80002688:	e426                	sd	s1,8(sp)
    8000268a:	e04a                	sd	s2,0(sp)
    8000268c:	1000                	addi	s0,sp,32
    8000268e:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002690:	01050913          	addi	s2,a0,16
    80002694:	854a                	mv	a0,s2
    80002696:	00001097          	auipc	ra,0x1
    8000269a:	42a080e7          	jalr	1066(ra) # 80003ac0 <holdingsleep>
    8000269e:	c92d                	beqz	a0,80002710 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800026a0:	854a                	mv	a0,s2
    800026a2:	00001097          	auipc	ra,0x1
    800026a6:	3da080e7          	jalr	986(ra) # 80003a7c <releasesleep>

  acquire(&bcache.lock);
    800026aa:	0000c517          	auipc	a0,0xc
    800026ae:	34e50513          	addi	a0,a0,846 # 8000e9f8 <bcache>
    800026b2:	00004097          	auipc	ra,0x4
    800026b6:	d0a080e7          	jalr	-758(ra) # 800063bc <acquire>
  b->refcnt--;
    800026ba:	40bc                	lw	a5,64(s1)
    800026bc:	37fd                	addiw	a5,a5,-1
    800026be:	0007871b          	sext.w	a4,a5
    800026c2:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800026c4:	eb05                	bnez	a4,800026f4 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800026c6:	68bc                	ld	a5,80(s1)
    800026c8:	64b8                	ld	a4,72(s1)
    800026ca:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800026cc:	64bc                	ld	a5,72(s1)
    800026ce:	68b8                	ld	a4,80(s1)
    800026d0:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800026d2:	00014797          	auipc	a5,0x14
    800026d6:	32678793          	addi	a5,a5,806 # 800169f8 <bcache+0x8000>
    800026da:	2b87b703          	ld	a4,696(a5)
    800026de:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800026e0:	00014717          	auipc	a4,0x14
    800026e4:	58070713          	addi	a4,a4,1408 # 80016c60 <bcache+0x8268>
    800026e8:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800026ea:	2b87b703          	ld	a4,696(a5)
    800026ee:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800026f0:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800026f4:	0000c517          	auipc	a0,0xc
    800026f8:	30450513          	addi	a0,a0,772 # 8000e9f8 <bcache>
    800026fc:	00004097          	auipc	ra,0x4
    80002700:	d74080e7          	jalr	-652(ra) # 80006470 <release>
}
    80002704:	60e2                	ld	ra,24(sp)
    80002706:	6442                	ld	s0,16(sp)
    80002708:	64a2                	ld	s1,8(sp)
    8000270a:	6902                	ld	s2,0(sp)
    8000270c:	6105                	addi	sp,sp,32
    8000270e:	8082                	ret
    panic("brelse");
    80002710:	00006517          	auipc	a0,0x6
    80002714:	e4850513          	addi	a0,a0,-440 # 80008558 <syscalls+0x128>
    80002718:	00003097          	auipc	ra,0x3
    8000271c:	75a080e7          	jalr	1882(ra) # 80005e72 <panic>

0000000080002720 <bpin>:

void
bpin(struct buf *b) {
    80002720:	1101                	addi	sp,sp,-32
    80002722:	ec06                	sd	ra,24(sp)
    80002724:	e822                	sd	s0,16(sp)
    80002726:	e426                	sd	s1,8(sp)
    80002728:	1000                	addi	s0,sp,32
    8000272a:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000272c:	0000c517          	auipc	a0,0xc
    80002730:	2cc50513          	addi	a0,a0,716 # 8000e9f8 <bcache>
    80002734:	00004097          	auipc	ra,0x4
    80002738:	c88080e7          	jalr	-888(ra) # 800063bc <acquire>
  b->refcnt++;
    8000273c:	40bc                	lw	a5,64(s1)
    8000273e:	2785                	addiw	a5,a5,1
    80002740:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002742:	0000c517          	auipc	a0,0xc
    80002746:	2b650513          	addi	a0,a0,694 # 8000e9f8 <bcache>
    8000274a:	00004097          	auipc	ra,0x4
    8000274e:	d26080e7          	jalr	-730(ra) # 80006470 <release>
}
    80002752:	60e2                	ld	ra,24(sp)
    80002754:	6442                	ld	s0,16(sp)
    80002756:	64a2                	ld	s1,8(sp)
    80002758:	6105                	addi	sp,sp,32
    8000275a:	8082                	ret

000000008000275c <bunpin>:

void
bunpin(struct buf *b) {
    8000275c:	1101                	addi	sp,sp,-32
    8000275e:	ec06                	sd	ra,24(sp)
    80002760:	e822                	sd	s0,16(sp)
    80002762:	e426                	sd	s1,8(sp)
    80002764:	1000                	addi	s0,sp,32
    80002766:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002768:	0000c517          	auipc	a0,0xc
    8000276c:	29050513          	addi	a0,a0,656 # 8000e9f8 <bcache>
    80002770:	00004097          	auipc	ra,0x4
    80002774:	c4c080e7          	jalr	-948(ra) # 800063bc <acquire>
  b->refcnt--;
    80002778:	40bc                	lw	a5,64(s1)
    8000277a:	37fd                	addiw	a5,a5,-1
    8000277c:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000277e:	0000c517          	auipc	a0,0xc
    80002782:	27a50513          	addi	a0,a0,634 # 8000e9f8 <bcache>
    80002786:	00004097          	auipc	ra,0x4
    8000278a:	cea080e7          	jalr	-790(ra) # 80006470 <release>
}
    8000278e:	60e2                	ld	ra,24(sp)
    80002790:	6442                	ld	s0,16(sp)
    80002792:	64a2                	ld	s1,8(sp)
    80002794:	6105                	addi	sp,sp,32
    80002796:	8082                	ret

0000000080002798 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002798:	1101                	addi	sp,sp,-32
    8000279a:	ec06                	sd	ra,24(sp)
    8000279c:	e822                	sd	s0,16(sp)
    8000279e:	e426                	sd	s1,8(sp)
    800027a0:	e04a                	sd	s2,0(sp)
    800027a2:	1000                	addi	s0,sp,32
    800027a4:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800027a6:	00d5d59b          	srliw	a1,a1,0xd
    800027aa:	00015797          	auipc	a5,0x15
    800027ae:	92a7a783          	lw	a5,-1750(a5) # 800170d4 <sb+0x1c>
    800027b2:	9dbd                	addw	a1,a1,a5
    800027b4:	00000097          	auipc	ra,0x0
    800027b8:	d9e080e7          	jalr	-610(ra) # 80002552 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800027bc:	0074f713          	andi	a4,s1,7
    800027c0:	4785                	li	a5,1
    800027c2:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800027c6:	14ce                	slli	s1,s1,0x33
    800027c8:	90d9                	srli	s1,s1,0x36
    800027ca:	00950733          	add	a4,a0,s1
    800027ce:	05874703          	lbu	a4,88(a4)
    800027d2:	00e7f6b3          	and	a3,a5,a4
    800027d6:	c69d                	beqz	a3,80002804 <bfree+0x6c>
    800027d8:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800027da:	94aa                	add	s1,s1,a0
    800027dc:	fff7c793          	not	a5,a5
    800027e0:	8ff9                	and	a5,a5,a4
    800027e2:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    800027e6:	00001097          	auipc	ra,0x1
    800027ea:	120080e7          	jalr	288(ra) # 80003906 <log_write>
  brelse(bp);
    800027ee:	854a                	mv	a0,s2
    800027f0:	00000097          	auipc	ra,0x0
    800027f4:	e92080e7          	jalr	-366(ra) # 80002682 <brelse>
}
    800027f8:	60e2                	ld	ra,24(sp)
    800027fa:	6442                	ld	s0,16(sp)
    800027fc:	64a2                	ld	s1,8(sp)
    800027fe:	6902                	ld	s2,0(sp)
    80002800:	6105                	addi	sp,sp,32
    80002802:	8082                	ret
    panic("freeing free block");
    80002804:	00006517          	auipc	a0,0x6
    80002808:	d5c50513          	addi	a0,a0,-676 # 80008560 <syscalls+0x130>
    8000280c:	00003097          	auipc	ra,0x3
    80002810:	666080e7          	jalr	1638(ra) # 80005e72 <panic>

0000000080002814 <balloc>:
{
    80002814:	711d                	addi	sp,sp,-96
    80002816:	ec86                	sd	ra,88(sp)
    80002818:	e8a2                	sd	s0,80(sp)
    8000281a:	e4a6                	sd	s1,72(sp)
    8000281c:	e0ca                	sd	s2,64(sp)
    8000281e:	fc4e                	sd	s3,56(sp)
    80002820:	f852                	sd	s4,48(sp)
    80002822:	f456                	sd	s5,40(sp)
    80002824:	f05a                	sd	s6,32(sp)
    80002826:	ec5e                	sd	s7,24(sp)
    80002828:	e862                	sd	s8,16(sp)
    8000282a:	e466                	sd	s9,8(sp)
    8000282c:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000282e:	00015797          	auipc	a5,0x15
    80002832:	88e7a783          	lw	a5,-1906(a5) # 800170bc <sb+0x4>
    80002836:	10078163          	beqz	a5,80002938 <balloc+0x124>
    8000283a:	8baa                	mv	s7,a0
    8000283c:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000283e:	00015b17          	auipc	s6,0x15
    80002842:	87ab0b13          	addi	s6,s6,-1926 # 800170b8 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002846:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002848:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000284a:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000284c:	6c89                	lui	s9,0x2
    8000284e:	a061                	j	800028d6 <balloc+0xc2>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002850:	974a                	add	a4,a4,s2
    80002852:	8fd5                	or	a5,a5,a3
    80002854:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    80002858:	854a                	mv	a0,s2
    8000285a:	00001097          	auipc	ra,0x1
    8000285e:	0ac080e7          	jalr	172(ra) # 80003906 <log_write>
        brelse(bp);
    80002862:	854a                	mv	a0,s2
    80002864:	00000097          	auipc	ra,0x0
    80002868:	e1e080e7          	jalr	-482(ra) # 80002682 <brelse>
  bp = bread(dev, bno);
    8000286c:	85a6                	mv	a1,s1
    8000286e:	855e                	mv	a0,s7
    80002870:	00000097          	auipc	ra,0x0
    80002874:	ce2080e7          	jalr	-798(ra) # 80002552 <bread>
    80002878:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000287a:	40000613          	li	a2,1024
    8000287e:	4581                	li	a1,0
    80002880:	05850513          	addi	a0,a0,88
    80002884:	ffffe097          	auipc	ra,0xffffe
    80002888:	8f4080e7          	jalr	-1804(ra) # 80000178 <memset>
  log_write(bp);
    8000288c:	854a                	mv	a0,s2
    8000288e:	00001097          	auipc	ra,0x1
    80002892:	078080e7          	jalr	120(ra) # 80003906 <log_write>
  brelse(bp);
    80002896:	854a                	mv	a0,s2
    80002898:	00000097          	auipc	ra,0x0
    8000289c:	dea080e7          	jalr	-534(ra) # 80002682 <brelse>
}
    800028a0:	8526                	mv	a0,s1
    800028a2:	60e6                	ld	ra,88(sp)
    800028a4:	6446                	ld	s0,80(sp)
    800028a6:	64a6                	ld	s1,72(sp)
    800028a8:	6906                	ld	s2,64(sp)
    800028aa:	79e2                	ld	s3,56(sp)
    800028ac:	7a42                	ld	s4,48(sp)
    800028ae:	7aa2                	ld	s5,40(sp)
    800028b0:	7b02                	ld	s6,32(sp)
    800028b2:	6be2                	ld	s7,24(sp)
    800028b4:	6c42                	ld	s8,16(sp)
    800028b6:	6ca2                	ld	s9,8(sp)
    800028b8:	6125                	addi	sp,sp,96
    800028ba:	8082                	ret
    brelse(bp);
    800028bc:	854a                	mv	a0,s2
    800028be:	00000097          	auipc	ra,0x0
    800028c2:	dc4080e7          	jalr	-572(ra) # 80002682 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800028c6:	015c87bb          	addw	a5,s9,s5
    800028ca:	00078a9b          	sext.w	s5,a5
    800028ce:	004b2703          	lw	a4,4(s6)
    800028d2:	06eaf363          	bgeu	s5,a4,80002938 <balloc+0x124>
    bp = bread(dev, BBLOCK(b, sb));
    800028d6:	41fad79b          	sraiw	a5,s5,0x1f
    800028da:	0137d79b          	srliw	a5,a5,0x13
    800028de:	015787bb          	addw	a5,a5,s5
    800028e2:	40d7d79b          	sraiw	a5,a5,0xd
    800028e6:	01cb2583          	lw	a1,28(s6)
    800028ea:	9dbd                	addw	a1,a1,a5
    800028ec:	855e                	mv	a0,s7
    800028ee:	00000097          	auipc	ra,0x0
    800028f2:	c64080e7          	jalr	-924(ra) # 80002552 <bread>
    800028f6:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800028f8:	004b2503          	lw	a0,4(s6)
    800028fc:	000a849b          	sext.w	s1,s5
    80002900:	8662                	mv	a2,s8
    80002902:	faa4fde3          	bgeu	s1,a0,800028bc <balloc+0xa8>
      m = 1 << (bi % 8);
    80002906:	41f6579b          	sraiw	a5,a2,0x1f
    8000290a:	01d7d69b          	srliw	a3,a5,0x1d
    8000290e:	00c6873b          	addw	a4,a3,a2
    80002912:	00777793          	andi	a5,a4,7
    80002916:	9f95                	subw	a5,a5,a3
    80002918:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000291c:	4037571b          	sraiw	a4,a4,0x3
    80002920:	00e906b3          	add	a3,s2,a4
    80002924:	0586c683          	lbu	a3,88(a3)
    80002928:	00d7f5b3          	and	a1,a5,a3
    8000292c:	d195                	beqz	a1,80002850 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000292e:	2605                	addiw	a2,a2,1
    80002930:	2485                	addiw	s1,s1,1
    80002932:	fd4618e3          	bne	a2,s4,80002902 <balloc+0xee>
    80002936:	b759                	j	800028bc <balloc+0xa8>
  printf("balloc: out of blocks\n");
    80002938:	00006517          	auipc	a0,0x6
    8000293c:	c4050513          	addi	a0,a0,-960 # 80008578 <syscalls+0x148>
    80002940:	00003097          	auipc	ra,0x3
    80002944:	57c080e7          	jalr	1404(ra) # 80005ebc <printf>
  return 0;
    80002948:	4481                	li	s1,0
    8000294a:	bf99                	j	800028a0 <balloc+0x8c>

000000008000294c <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    8000294c:	7179                	addi	sp,sp,-48
    8000294e:	f406                	sd	ra,40(sp)
    80002950:	f022                	sd	s0,32(sp)
    80002952:	ec26                	sd	s1,24(sp)
    80002954:	e84a                	sd	s2,16(sp)
    80002956:	e44e                	sd	s3,8(sp)
    80002958:	e052                	sd	s4,0(sp)
    8000295a:	1800                	addi	s0,sp,48
    8000295c:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000295e:	47ad                	li	a5,11
    80002960:	02b7e763          	bltu	a5,a1,8000298e <bmap+0x42>
    if((addr = ip->addrs[bn]) == 0){
    80002964:	02059493          	slli	s1,a1,0x20
    80002968:	9081                	srli	s1,s1,0x20
    8000296a:	048a                	slli	s1,s1,0x2
    8000296c:	94aa                	add	s1,s1,a0
    8000296e:	0504a903          	lw	s2,80(s1)
    80002972:	06091e63          	bnez	s2,800029ee <bmap+0xa2>
      addr = balloc(ip->dev);
    80002976:	4108                	lw	a0,0(a0)
    80002978:	00000097          	auipc	ra,0x0
    8000297c:	e9c080e7          	jalr	-356(ra) # 80002814 <balloc>
    80002980:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002984:	06090563          	beqz	s2,800029ee <bmap+0xa2>
        return 0;
      ip->addrs[bn] = addr;
    80002988:	0524a823          	sw	s2,80(s1)
    8000298c:	a08d                	j	800029ee <bmap+0xa2>
    }
    return addr;
  }
  bn -= NDIRECT;
    8000298e:	ff45849b          	addiw	s1,a1,-12
    80002992:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002996:	0ff00793          	li	a5,255
    8000299a:	08e7e563          	bltu	a5,a4,80002a24 <bmap+0xd8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    8000299e:	08052903          	lw	s2,128(a0)
    800029a2:	00091d63          	bnez	s2,800029bc <bmap+0x70>
      addr = balloc(ip->dev);
    800029a6:	4108                	lw	a0,0(a0)
    800029a8:	00000097          	auipc	ra,0x0
    800029ac:	e6c080e7          	jalr	-404(ra) # 80002814 <balloc>
    800029b0:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800029b4:	02090d63          	beqz	s2,800029ee <bmap+0xa2>
        return 0;
      ip->addrs[NDIRECT] = addr;
    800029b8:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    800029bc:	85ca                	mv	a1,s2
    800029be:	0009a503          	lw	a0,0(s3)
    800029c2:	00000097          	auipc	ra,0x0
    800029c6:	b90080e7          	jalr	-1136(ra) # 80002552 <bread>
    800029ca:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800029cc:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800029d0:	02049593          	slli	a1,s1,0x20
    800029d4:	9181                	srli	a1,a1,0x20
    800029d6:	058a                	slli	a1,a1,0x2
    800029d8:	00b784b3          	add	s1,a5,a1
    800029dc:	0004a903          	lw	s2,0(s1)
    800029e0:	02090063          	beqz	s2,80002a00 <bmap+0xb4>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800029e4:	8552                	mv	a0,s4
    800029e6:	00000097          	auipc	ra,0x0
    800029ea:	c9c080e7          	jalr	-868(ra) # 80002682 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800029ee:	854a                	mv	a0,s2
    800029f0:	70a2                	ld	ra,40(sp)
    800029f2:	7402                	ld	s0,32(sp)
    800029f4:	64e2                	ld	s1,24(sp)
    800029f6:	6942                	ld	s2,16(sp)
    800029f8:	69a2                	ld	s3,8(sp)
    800029fa:	6a02                	ld	s4,0(sp)
    800029fc:	6145                	addi	sp,sp,48
    800029fe:	8082                	ret
      addr = balloc(ip->dev);
    80002a00:	0009a503          	lw	a0,0(s3)
    80002a04:	00000097          	auipc	ra,0x0
    80002a08:	e10080e7          	jalr	-496(ra) # 80002814 <balloc>
    80002a0c:	0005091b          	sext.w	s2,a0
      if(addr){
    80002a10:	fc090ae3          	beqz	s2,800029e4 <bmap+0x98>
        a[bn] = addr;
    80002a14:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002a18:	8552                	mv	a0,s4
    80002a1a:	00001097          	auipc	ra,0x1
    80002a1e:	eec080e7          	jalr	-276(ra) # 80003906 <log_write>
    80002a22:	b7c9                	j	800029e4 <bmap+0x98>
  panic("bmap: out of range");
    80002a24:	00006517          	auipc	a0,0x6
    80002a28:	b6c50513          	addi	a0,a0,-1172 # 80008590 <syscalls+0x160>
    80002a2c:	00003097          	auipc	ra,0x3
    80002a30:	446080e7          	jalr	1094(ra) # 80005e72 <panic>

0000000080002a34 <iget>:
{
    80002a34:	7179                	addi	sp,sp,-48
    80002a36:	f406                	sd	ra,40(sp)
    80002a38:	f022                	sd	s0,32(sp)
    80002a3a:	ec26                	sd	s1,24(sp)
    80002a3c:	e84a                	sd	s2,16(sp)
    80002a3e:	e44e                	sd	s3,8(sp)
    80002a40:	e052                	sd	s4,0(sp)
    80002a42:	1800                	addi	s0,sp,48
    80002a44:	89aa                	mv	s3,a0
    80002a46:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002a48:	00014517          	auipc	a0,0x14
    80002a4c:	69050513          	addi	a0,a0,1680 # 800170d8 <itable>
    80002a50:	00004097          	auipc	ra,0x4
    80002a54:	96c080e7          	jalr	-1684(ra) # 800063bc <acquire>
  empty = 0;
    80002a58:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a5a:	00014497          	auipc	s1,0x14
    80002a5e:	69648493          	addi	s1,s1,1686 # 800170f0 <itable+0x18>
    80002a62:	00016697          	auipc	a3,0x16
    80002a66:	11e68693          	addi	a3,a3,286 # 80018b80 <log>
    80002a6a:	a039                	j	80002a78 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a6c:	02090b63          	beqz	s2,80002aa2 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a70:	08848493          	addi	s1,s1,136
    80002a74:	02d48a63          	beq	s1,a3,80002aa8 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002a78:	449c                	lw	a5,8(s1)
    80002a7a:	fef059e3          	blez	a5,80002a6c <iget+0x38>
    80002a7e:	4098                	lw	a4,0(s1)
    80002a80:	ff3716e3          	bne	a4,s3,80002a6c <iget+0x38>
    80002a84:	40d8                	lw	a4,4(s1)
    80002a86:	ff4713e3          	bne	a4,s4,80002a6c <iget+0x38>
      ip->ref++;
    80002a8a:	2785                	addiw	a5,a5,1
    80002a8c:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002a8e:	00014517          	auipc	a0,0x14
    80002a92:	64a50513          	addi	a0,a0,1610 # 800170d8 <itable>
    80002a96:	00004097          	auipc	ra,0x4
    80002a9a:	9da080e7          	jalr	-1574(ra) # 80006470 <release>
      return ip;
    80002a9e:	8926                	mv	s2,s1
    80002aa0:	a03d                	j	80002ace <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002aa2:	f7f9                	bnez	a5,80002a70 <iget+0x3c>
    80002aa4:	8926                	mv	s2,s1
    80002aa6:	b7e9                	j	80002a70 <iget+0x3c>
  if(empty == 0)
    80002aa8:	02090c63          	beqz	s2,80002ae0 <iget+0xac>
  ip->dev = dev;
    80002aac:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002ab0:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002ab4:	4785                	li	a5,1
    80002ab6:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002aba:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002abe:	00014517          	auipc	a0,0x14
    80002ac2:	61a50513          	addi	a0,a0,1562 # 800170d8 <itable>
    80002ac6:	00004097          	auipc	ra,0x4
    80002aca:	9aa080e7          	jalr	-1622(ra) # 80006470 <release>
}
    80002ace:	854a                	mv	a0,s2
    80002ad0:	70a2                	ld	ra,40(sp)
    80002ad2:	7402                	ld	s0,32(sp)
    80002ad4:	64e2                	ld	s1,24(sp)
    80002ad6:	6942                	ld	s2,16(sp)
    80002ad8:	69a2                	ld	s3,8(sp)
    80002ada:	6a02                	ld	s4,0(sp)
    80002adc:	6145                	addi	sp,sp,48
    80002ade:	8082                	ret
    panic("iget: no inodes");
    80002ae0:	00006517          	auipc	a0,0x6
    80002ae4:	ac850513          	addi	a0,a0,-1336 # 800085a8 <syscalls+0x178>
    80002ae8:	00003097          	auipc	ra,0x3
    80002aec:	38a080e7          	jalr	906(ra) # 80005e72 <panic>

0000000080002af0 <fsinit>:
fsinit(int dev) {
    80002af0:	7179                	addi	sp,sp,-48
    80002af2:	f406                	sd	ra,40(sp)
    80002af4:	f022                	sd	s0,32(sp)
    80002af6:	ec26                	sd	s1,24(sp)
    80002af8:	e84a                	sd	s2,16(sp)
    80002afa:	e44e                	sd	s3,8(sp)
    80002afc:	1800                	addi	s0,sp,48
    80002afe:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002b00:	4585                	li	a1,1
    80002b02:	00000097          	auipc	ra,0x0
    80002b06:	a50080e7          	jalr	-1456(ra) # 80002552 <bread>
    80002b0a:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002b0c:	00014997          	auipc	s3,0x14
    80002b10:	5ac98993          	addi	s3,s3,1452 # 800170b8 <sb>
    80002b14:	02000613          	li	a2,32
    80002b18:	05850593          	addi	a1,a0,88
    80002b1c:	854e                	mv	a0,s3
    80002b1e:	ffffd097          	auipc	ra,0xffffd
    80002b22:	6ba080e7          	jalr	1722(ra) # 800001d8 <memmove>
  brelse(bp);
    80002b26:	8526                	mv	a0,s1
    80002b28:	00000097          	auipc	ra,0x0
    80002b2c:	b5a080e7          	jalr	-1190(ra) # 80002682 <brelse>
  if(sb.magic != FSMAGIC)
    80002b30:	0009a703          	lw	a4,0(s3)
    80002b34:	102037b7          	lui	a5,0x10203
    80002b38:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002b3c:	02f71263          	bne	a4,a5,80002b60 <fsinit+0x70>
  initlog(dev, &sb);
    80002b40:	00014597          	auipc	a1,0x14
    80002b44:	57858593          	addi	a1,a1,1400 # 800170b8 <sb>
    80002b48:	854a                	mv	a0,s2
    80002b4a:	00001097          	auipc	ra,0x1
    80002b4e:	b40080e7          	jalr	-1216(ra) # 8000368a <initlog>
}
    80002b52:	70a2                	ld	ra,40(sp)
    80002b54:	7402                	ld	s0,32(sp)
    80002b56:	64e2                	ld	s1,24(sp)
    80002b58:	6942                	ld	s2,16(sp)
    80002b5a:	69a2                	ld	s3,8(sp)
    80002b5c:	6145                	addi	sp,sp,48
    80002b5e:	8082                	ret
    panic("invalid file system");
    80002b60:	00006517          	auipc	a0,0x6
    80002b64:	a5850513          	addi	a0,a0,-1448 # 800085b8 <syscalls+0x188>
    80002b68:	00003097          	auipc	ra,0x3
    80002b6c:	30a080e7          	jalr	778(ra) # 80005e72 <panic>

0000000080002b70 <iinit>:
{
    80002b70:	7179                	addi	sp,sp,-48
    80002b72:	f406                	sd	ra,40(sp)
    80002b74:	f022                	sd	s0,32(sp)
    80002b76:	ec26                	sd	s1,24(sp)
    80002b78:	e84a                	sd	s2,16(sp)
    80002b7a:	e44e                	sd	s3,8(sp)
    80002b7c:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002b7e:	00006597          	auipc	a1,0x6
    80002b82:	a5258593          	addi	a1,a1,-1454 # 800085d0 <syscalls+0x1a0>
    80002b86:	00014517          	auipc	a0,0x14
    80002b8a:	55250513          	addi	a0,a0,1362 # 800170d8 <itable>
    80002b8e:	00003097          	auipc	ra,0x3
    80002b92:	79e080e7          	jalr	1950(ra) # 8000632c <initlock>
  for(i = 0; i < NINODE; i++) {
    80002b96:	00014497          	auipc	s1,0x14
    80002b9a:	56a48493          	addi	s1,s1,1386 # 80017100 <itable+0x28>
    80002b9e:	00016997          	auipc	s3,0x16
    80002ba2:	ff298993          	addi	s3,s3,-14 # 80018b90 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002ba6:	00006917          	auipc	s2,0x6
    80002baa:	a3290913          	addi	s2,s2,-1486 # 800085d8 <syscalls+0x1a8>
    80002bae:	85ca                	mv	a1,s2
    80002bb0:	8526                	mv	a0,s1
    80002bb2:	00001097          	auipc	ra,0x1
    80002bb6:	e3a080e7          	jalr	-454(ra) # 800039ec <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002bba:	08848493          	addi	s1,s1,136
    80002bbe:	ff3498e3          	bne	s1,s3,80002bae <iinit+0x3e>
}
    80002bc2:	70a2                	ld	ra,40(sp)
    80002bc4:	7402                	ld	s0,32(sp)
    80002bc6:	64e2                	ld	s1,24(sp)
    80002bc8:	6942                	ld	s2,16(sp)
    80002bca:	69a2                	ld	s3,8(sp)
    80002bcc:	6145                	addi	sp,sp,48
    80002bce:	8082                	ret

0000000080002bd0 <ialloc>:
{
    80002bd0:	715d                	addi	sp,sp,-80
    80002bd2:	e486                	sd	ra,72(sp)
    80002bd4:	e0a2                	sd	s0,64(sp)
    80002bd6:	fc26                	sd	s1,56(sp)
    80002bd8:	f84a                	sd	s2,48(sp)
    80002bda:	f44e                	sd	s3,40(sp)
    80002bdc:	f052                	sd	s4,32(sp)
    80002bde:	ec56                	sd	s5,24(sp)
    80002be0:	e85a                	sd	s6,16(sp)
    80002be2:	e45e                	sd	s7,8(sp)
    80002be4:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002be6:	00014717          	auipc	a4,0x14
    80002bea:	4de72703          	lw	a4,1246(a4) # 800170c4 <sb+0xc>
    80002bee:	4785                	li	a5,1
    80002bf0:	04e7fa63          	bgeu	a5,a4,80002c44 <ialloc+0x74>
    80002bf4:	8aaa                	mv	s5,a0
    80002bf6:	8bae                	mv	s7,a1
    80002bf8:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002bfa:	00014a17          	auipc	s4,0x14
    80002bfe:	4bea0a13          	addi	s4,s4,1214 # 800170b8 <sb>
    80002c02:	00048b1b          	sext.w	s6,s1
    80002c06:	0044d593          	srli	a1,s1,0x4
    80002c0a:	018a2783          	lw	a5,24(s4)
    80002c0e:	9dbd                	addw	a1,a1,a5
    80002c10:	8556                	mv	a0,s5
    80002c12:	00000097          	auipc	ra,0x0
    80002c16:	940080e7          	jalr	-1728(ra) # 80002552 <bread>
    80002c1a:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002c1c:	05850993          	addi	s3,a0,88
    80002c20:	00f4f793          	andi	a5,s1,15
    80002c24:	079a                	slli	a5,a5,0x6
    80002c26:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002c28:	00099783          	lh	a5,0(s3)
    80002c2c:	c3a1                	beqz	a5,80002c6c <ialloc+0x9c>
    brelse(bp);
    80002c2e:	00000097          	auipc	ra,0x0
    80002c32:	a54080e7          	jalr	-1452(ra) # 80002682 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002c36:	0485                	addi	s1,s1,1
    80002c38:	00ca2703          	lw	a4,12(s4)
    80002c3c:	0004879b          	sext.w	a5,s1
    80002c40:	fce7e1e3          	bltu	a5,a4,80002c02 <ialloc+0x32>
  printf("ialloc: no inodes\n");
    80002c44:	00006517          	auipc	a0,0x6
    80002c48:	99c50513          	addi	a0,a0,-1636 # 800085e0 <syscalls+0x1b0>
    80002c4c:	00003097          	auipc	ra,0x3
    80002c50:	270080e7          	jalr	624(ra) # 80005ebc <printf>
  return 0;
    80002c54:	4501                	li	a0,0
}
    80002c56:	60a6                	ld	ra,72(sp)
    80002c58:	6406                	ld	s0,64(sp)
    80002c5a:	74e2                	ld	s1,56(sp)
    80002c5c:	7942                	ld	s2,48(sp)
    80002c5e:	79a2                	ld	s3,40(sp)
    80002c60:	7a02                	ld	s4,32(sp)
    80002c62:	6ae2                	ld	s5,24(sp)
    80002c64:	6b42                	ld	s6,16(sp)
    80002c66:	6ba2                	ld	s7,8(sp)
    80002c68:	6161                	addi	sp,sp,80
    80002c6a:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002c6c:	04000613          	li	a2,64
    80002c70:	4581                	li	a1,0
    80002c72:	854e                	mv	a0,s3
    80002c74:	ffffd097          	auipc	ra,0xffffd
    80002c78:	504080e7          	jalr	1284(ra) # 80000178 <memset>
      dip->type = type;
    80002c7c:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002c80:	854a                	mv	a0,s2
    80002c82:	00001097          	auipc	ra,0x1
    80002c86:	c84080e7          	jalr	-892(ra) # 80003906 <log_write>
      brelse(bp);
    80002c8a:	854a                	mv	a0,s2
    80002c8c:	00000097          	auipc	ra,0x0
    80002c90:	9f6080e7          	jalr	-1546(ra) # 80002682 <brelse>
      return iget(dev, inum);
    80002c94:	85da                	mv	a1,s6
    80002c96:	8556                	mv	a0,s5
    80002c98:	00000097          	auipc	ra,0x0
    80002c9c:	d9c080e7          	jalr	-612(ra) # 80002a34 <iget>
    80002ca0:	bf5d                	j	80002c56 <ialloc+0x86>

0000000080002ca2 <iupdate>:
{
    80002ca2:	1101                	addi	sp,sp,-32
    80002ca4:	ec06                	sd	ra,24(sp)
    80002ca6:	e822                	sd	s0,16(sp)
    80002ca8:	e426                	sd	s1,8(sp)
    80002caa:	e04a                	sd	s2,0(sp)
    80002cac:	1000                	addi	s0,sp,32
    80002cae:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002cb0:	415c                	lw	a5,4(a0)
    80002cb2:	0047d79b          	srliw	a5,a5,0x4
    80002cb6:	00014597          	auipc	a1,0x14
    80002cba:	41a5a583          	lw	a1,1050(a1) # 800170d0 <sb+0x18>
    80002cbe:	9dbd                	addw	a1,a1,a5
    80002cc0:	4108                	lw	a0,0(a0)
    80002cc2:	00000097          	auipc	ra,0x0
    80002cc6:	890080e7          	jalr	-1904(ra) # 80002552 <bread>
    80002cca:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002ccc:	05850793          	addi	a5,a0,88
    80002cd0:	40c8                	lw	a0,4(s1)
    80002cd2:	893d                	andi	a0,a0,15
    80002cd4:	051a                	slli	a0,a0,0x6
    80002cd6:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002cd8:	04449703          	lh	a4,68(s1)
    80002cdc:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002ce0:	04649703          	lh	a4,70(s1)
    80002ce4:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002ce8:	04849703          	lh	a4,72(s1)
    80002cec:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002cf0:	04a49703          	lh	a4,74(s1)
    80002cf4:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002cf8:	44f8                	lw	a4,76(s1)
    80002cfa:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002cfc:	03400613          	li	a2,52
    80002d00:	05048593          	addi	a1,s1,80
    80002d04:	0531                	addi	a0,a0,12
    80002d06:	ffffd097          	auipc	ra,0xffffd
    80002d0a:	4d2080e7          	jalr	1234(ra) # 800001d8 <memmove>
  log_write(bp);
    80002d0e:	854a                	mv	a0,s2
    80002d10:	00001097          	auipc	ra,0x1
    80002d14:	bf6080e7          	jalr	-1034(ra) # 80003906 <log_write>
  brelse(bp);
    80002d18:	854a                	mv	a0,s2
    80002d1a:	00000097          	auipc	ra,0x0
    80002d1e:	968080e7          	jalr	-1688(ra) # 80002682 <brelse>
}
    80002d22:	60e2                	ld	ra,24(sp)
    80002d24:	6442                	ld	s0,16(sp)
    80002d26:	64a2                	ld	s1,8(sp)
    80002d28:	6902                	ld	s2,0(sp)
    80002d2a:	6105                	addi	sp,sp,32
    80002d2c:	8082                	ret

0000000080002d2e <idup>:
{
    80002d2e:	1101                	addi	sp,sp,-32
    80002d30:	ec06                	sd	ra,24(sp)
    80002d32:	e822                	sd	s0,16(sp)
    80002d34:	e426                	sd	s1,8(sp)
    80002d36:	1000                	addi	s0,sp,32
    80002d38:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002d3a:	00014517          	auipc	a0,0x14
    80002d3e:	39e50513          	addi	a0,a0,926 # 800170d8 <itable>
    80002d42:	00003097          	auipc	ra,0x3
    80002d46:	67a080e7          	jalr	1658(ra) # 800063bc <acquire>
  ip->ref++;
    80002d4a:	449c                	lw	a5,8(s1)
    80002d4c:	2785                	addiw	a5,a5,1
    80002d4e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002d50:	00014517          	auipc	a0,0x14
    80002d54:	38850513          	addi	a0,a0,904 # 800170d8 <itable>
    80002d58:	00003097          	auipc	ra,0x3
    80002d5c:	718080e7          	jalr	1816(ra) # 80006470 <release>
}
    80002d60:	8526                	mv	a0,s1
    80002d62:	60e2                	ld	ra,24(sp)
    80002d64:	6442                	ld	s0,16(sp)
    80002d66:	64a2                	ld	s1,8(sp)
    80002d68:	6105                	addi	sp,sp,32
    80002d6a:	8082                	ret

0000000080002d6c <ilock>:
{
    80002d6c:	1101                	addi	sp,sp,-32
    80002d6e:	ec06                	sd	ra,24(sp)
    80002d70:	e822                	sd	s0,16(sp)
    80002d72:	e426                	sd	s1,8(sp)
    80002d74:	e04a                	sd	s2,0(sp)
    80002d76:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002d78:	c115                	beqz	a0,80002d9c <ilock+0x30>
    80002d7a:	84aa                	mv	s1,a0
    80002d7c:	451c                	lw	a5,8(a0)
    80002d7e:	00f05f63          	blez	a5,80002d9c <ilock+0x30>
  acquiresleep(&ip->lock);
    80002d82:	0541                	addi	a0,a0,16
    80002d84:	00001097          	auipc	ra,0x1
    80002d88:	ca2080e7          	jalr	-862(ra) # 80003a26 <acquiresleep>
  if(ip->valid == 0){
    80002d8c:	40bc                	lw	a5,64(s1)
    80002d8e:	cf99                	beqz	a5,80002dac <ilock+0x40>
}
    80002d90:	60e2                	ld	ra,24(sp)
    80002d92:	6442                	ld	s0,16(sp)
    80002d94:	64a2                	ld	s1,8(sp)
    80002d96:	6902                	ld	s2,0(sp)
    80002d98:	6105                	addi	sp,sp,32
    80002d9a:	8082                	ret
    panic("ilock");
    80002d9c:	00006517          	auipc	a0,0x6
    80002da0:	85c50513          	addi	a0,a0,-1956 # 800085f8 <syscalls+0x1c8>
    80002da4:	00003097          	auipc	ra,0x3
    80002da8:	0ce080e7          	jalr	206(ra) # 80005e72 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002dac:	40dc                	lw	a5,4(s1)
    80002dae:	0047d79b          	srliw	a5,a5,0x4
    80002db2:	00014597          	auipc	a1,0x14
    80002db6:	31e5a583          	lw	a1,798(a1) # 800170d0 <sb+0x18>
    80002dba:	9dbd                	addw	a1,a1,a5
    80002dbc:	4088                	lw	a0,0(s1)
    80002dbe:	fffff097          	auipc	ra,0xfffff
    80002dc2:	794080e7          	jalr	1940(ra) # 80002552 <bread>
    80002dc6:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002dc8:	05850593          	addi	a1,a0,88
    80002dcc:	40dc                	lw	a5,4(s1)
    80002dce:	8bbd                	andi	a5,a5,15
    80002dd0:	079a                	slli	a5,a5,0x6
    80002dd2:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002dd4:	00059783          	lh	a5,0(a1)
    80002dd8:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002ddc:	00259783          	lh	a5,2(a1)
    80002de0:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002de4:	00459783          	lh	a5,4(a1)
    80002de8:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002dec:	00659783          	lh	a5,6(a1)
    80002df0:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002df4:	459c                	lw	a5,8(a1)
    80002df6:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002df8:	03400613          	li	a2,52
    80002dfc:	05b1                	addi	a1,a1,12
    80002dfe:	05048513          	addi	a0,s1,80
    80002e02:	ffffd097          	auipc	ra,0xffffd
    80002e06:	3d6080e7          	jalr	982(ra) # 800001d8 <memmove>
    brelse(bp);
    80002e0a:	854a                	mv	a0,s2
    80002e0c:	00000097          	auipc	ra,0x0
    80002e10:	876080e7          	jalr	-1930(ra) # 80002682 <brelse>
    ip->valid = 1;
    80002e14:	4785                	li	a5,1
    80002e16:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002e18:	04449783          	lh	a5,68(s1)
    80002e1c:	fbb5                	bnez	a5,80002d90 <ilock+0x24>
      panic("ilock: no type");
    80002e1e:	00005517          	auipc	a0,0x5
    80002e22:	7e250513          	addi	a0,a0,2018 # 80008600 <syscalls+0x1d0>
    80002e26:	00003097          	auipc	ra,0x3
    80002e2a:	04c080e7          	jalr	76(ra) # 80005e72 <panic>

0000000080002e2e <iunlock>:
{
    80002e2e:	1101                	addi	sp,sp,-32
    80002e30:	ec06                	sd	ra,24(sp)
    80002e32:	e822                	sd	s0,16(sp)
    80002e34:	e426                	sd	s1,8(sp)
    80002e36:	e04a                	sd	s2,0(sp)
    80002e38:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002e3a:	c905                	beqz	a0,80002e6a <iunlock+0x3c>
    80002e3c:	84aa                	mv	s1,a0
    80002e3e:	01050913          	addi	s2,a0,16
    80002e42:	854a                	mv	a0,s2
    80002e44:	00001097          	auipc	ra,0x1
    80002e48:	c7c080e7          	jalr	-900(ra) # 80003ac0 <holdingsleep>
    80002e4c:	cd19                	beqz	a0,80002e6a <iunlock+0x3c>
    80002e4e:	449c                	lw	a5,8(s1)
    80002e50:	00f05d63          	blez	a5,80002e6a <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002e54:	854a                	mv	a0,s2
    80002e56:	00001097          	auipc	ra,0x1
    80002e5a:	c26080e7          	jalr	-986(ra) # 80003a7c <releasesleep>
}
    80002e5e:	60e2                	ld	ra,24(sp)
    80002e60:	6442                	ld	s0,16(sp)
    80002e62:	64a2                	ld	s1,8(sp)
    80002e64:	6902                	ld	s2,0(sp)
    80002e66:	6105                	addi	sp,sp,32
    80002e68:	8082                	ret
    panic("iunlock");
    80002e6a:	00005517          	auipc	a0,0x5
    80002e6e:	7a650513          	addi	a0,a0,1958 # 80008610 <syscalls+0x1e0>
    80002e72:	00003097          	auipc	ra,0x3
    80002e76:	000080e7          	jalr	ra # 80005e72 <panic>

0000000080002e7a <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002e7a:	7179                	addi	sp,sp,-48
    80002e7c:	f406                	sd	ra,40(sp)
    80002e7e:	f022                	sd	s0,32(sp)
    80002e80:	ec26                	sd	s1,24(sp)
    80002e82:	e84a                	sd	s2,16(sp)
    80002e84:	e44e                	sd	s3,8(sp)
    80002e86:	e052                	sd	s4,0(sp)
    80002e88:	1800                	addi	s0,sp,48
    80002e8a:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002e8c:	05050493          	addi	s1,a0,80
    80002e90:	08050913          	addi	s2,a0,128
    80002e94:	a021                	j	80002e9c <itrunc+0x22>
    80002e96:	0491                	addi	s1,s1,4
    80002e98:	01248d63          	beq	s1,s2,80002eb2 <itrunc+0x38>
    if(ip->addrs[i]){
    80002e9c:	408c                	lw	a1,0(s1)
    80002e9e:	dde5                	beqz	a1,80002e96 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002ea0:	0009a503          	lw	a0,0(s3)
    80002ea4:	00000097          	auipc	ra,0x0
    80002ea8:	8f4080e7          	jalr	-1804(ra) # 80002798 <bfree>
      ip->addrs[i] = 0;
    80002eac:	0004a023          	sw	zero,0(s1)
    80002eb0:	b7dd                	j	80002e96 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002eb2:	0809a583          	lw	a1,128(s3)
    80002eb6:	e185                	bnez	a1,80002ed6 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002eb8:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002ebc:	854e                	mv	a0,s3
    80002ebe:	00000097          	auipc	ra,0x0
    80002ec2:	de4080e7          	jalr	-540(ra) # 80002ca2 <iupdate>
}
    80002ec6:	70a2                	ld	ra,40(sp)
    80002ec8:	7402                	ld	s0,32(sp)
    80002eca:	64e2                	ld	s1,24(sp)
    80002ecc:	6942                	ld	s2,16(sp)
    80002ece:	69a2                	ld	s3,8(sp)
    80002ed0:	6a02                	ld	s4,0(sp)
    80002ed2:	6145                	addi	sp,sp,48
    80002ed4:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002ed6:	0009a503          	lw	a0,0(s3)
    80002eda:	fffff097          	auipc	ra,0xfffff
    80002ede:	678080e7          	jalr	1656(ra) # 80002552 <bread>
    80002ee2:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002ee4:	05850493          	addi	s1,a0,88
    80002ee8:	45850913          	addi	s2,a0,1112
    80002eec:	a811                	j	80002f00 <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002eee:	0009a503          	lw	a0,0(s3)
    80002ef2:	00000097          	auipc	ra,0x0
    80002ef6:	8a6080e7          	jalr	-1882(ra) # 80002798 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002efa:	0491                	addi	s1,s1,4
    80002efc:	01248563          	beq	s1,s2,80002f06 <itrunc+0x8c>
      if(a[j])
    80002f00:	408c                	lw	a1,0(s1)
    80002f02:	dde5                	beqz	a1,80002efa <itrunc+0x80>
    80002f04:	b7ed                	j	80002eee <itrunc+0x74>
    brelse(bp);
    80002f06:	8552                	mv	a0,s4
    80002f08:	fffff097          	auipc	ra,0xfffff
    80002f0c:	77a080e7          	jalr	1914(ra) # 80002682 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002f10:	0809a583          	lw	a1,128(s3)
    80002f14:	0009a503          	lw	a0,0(s3)
    80002f18:	00000097          	auipc	ra,0x0
    80002f1c:	880080e7          	jalr	-1920(ra) # 80002798 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002f20:	0809a023          	sw	zero,128(s3)
    80002f24:	bf51                	j	80002eb8 <itrunc+0x3e>

0000000080002f26 <iput>:
{
    80002f26:	1101                	addi	sp,sp,-32
    80002f28:	ec06                	sd	ra,24(sp)
    80002f2a:	e822                	sd	s0,16(sp)
    80002f2c:	e426                	sd	s1,8(sp)
    80002f2e:	e04a                	sd	s2,0(sp)
    80002f30:	1000                	addi	s0,sp,32
    80002f32:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002f34:	00014517          	auipc	a0,0x14
    80002f38:	1a450513          	addi	a0,a0,420 # 800170d8 <itable>
    80002f3c:	00003097          	auipc	ra,0x3
    80002f40:	480080e7          	jalr	1152(ra) # 800063bc <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002f44:	4498                	lw	a4,8(s1)
    80002f46:	4785                	li	a5,1
    80002f48:	02f70363          	beq	a4,a5,80002f6e <iput+0x48>
  ip->ref--;
    80002f4c:	449c                	lw	a5,8(s1)
    80002f4e:	37fd                	addiw	a5,a5,-1
    80002f50:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002f52:	00014517          	auipc	a0,0x14
    80002f56:	18650513          	addi	a0,a0,390 # 800170d8 <itable>
    80002f5a:	00003097          	auipc	ra,0x3
    80002f5e:	516080e7          	jalr	1302(ra) # 80006470 <release>
}
    80002f62:	60e2                	ld	ra,24(sp)
    80002f64:	6442                	ld	s0,16(sp)
    80002f66:	64a2                	ld	s1,8(sp)
    80002f68:	6902                	ld	s2,0(sp)
    80002f6a:	6105                	addi	sp,sp,32
    80002f6c:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002f6e:	40bc                	lw	a5,64(s1)
    80002f70:	dff1                	beqz	a5,80002f4c <iput+0x26>
    80002f72:	04a49783          	lh	a5,74(s1)
    80002f76:	fbf9                	bnez	a5,80002f4c <iput+0x26>
    acquiresleep(&ip->lock);
    80002f78:	01048913          	addi	s2,s1,16
    80002f7c:	854a                	mv	a0,s2
    80002f7e:	00001097          	auipc	ra,0x1
    80002f82:	aa8080e7          	jalr	-1368(ra) # 80003a26 <acquiresleep>
    release(&itable.lock);
    80002f86:	00014517          	auipc	a0,0x14
    80002f8a:	15250513          	addi	a0,a0,338 # 800170d8 <itable>
    80002f8e:	00003097          	auipc	ra,0x3
    80002f92:	4e2080e7          	jalr	1250(ra) # 80006470 <release>
    itrunc(ip);
    80002f96:	8526                	mv	a0,s1
    80002f98:	00000097          	auipc	ra,0x0
    80002f9c:	ee2080e7          	jalr	-286(ra) # 80002e7a <itrunc>
    ip->type = 0;
    80002fa0:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002fa4:	8526                	mv	a0,s1
    80002fa6:	00000097          	auipc	ra,0x0
    80002faa:	cfc080e7          	jalr	-772(ra) # 80002ca2 <iupdate>
    ip->valid = 0;
    80002fae:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002fb2:	854a                	mv	a0,s2
    80002fb4:	00001097          	auipc	ra,0x1
    80002fb8:	ac8080e7          	jalr	-1336(ra) # 80003a7c <releasesleep>
    acquire(&itable.lock);
    80002fbc:	00014517          	auipc	a0,0x14
    80002fc0:	11c50513          	addi	a0,a0,284 # 800170d8 <itable>
    80002fc4:	00003097          	auipc	ra,0x3
    80002fc8:	3f8080e7          	jalr	1016(ra) # 800063bc <acquire>
    80002fcc:	b741                	j	80002f4c <iput+0x26>

0000000080002fce <iunlockput>:
{
    80002fce:	1101                	addi	sp,sp,-32
    80002fd0:	ec06                	sd	ra,24(sp)
    80002fd2:	e822                	sd	s0,16(sp)
    80002fd4:	e426                	sd	s1,8(sp)
    80002fd6:	1000                	addi	s0,sp,32
    80002fd8:	84aa                	mv	s1,a0
  iunlock(ip);
    80002fda:	00000097          	auipc	ra,0x0
    80002fde:	e54080e7          	jalr	-428(ra) # 80002e2e <iunlock>
  iput(ip);
    80002fe2:	8526                	mv	a0,s1
    80002fe4:	00000097          	auipc	ra,0x0
    80002fe8:	f42080e7          	jalr	-190(ra) # 80002f26 <iput>
}
    80002fec:	60e2                	ld	ra,24(sp)
    80002fee:	6442                	ld	s0,16(sp)
    80002ff0:	64a2                	ld	s1,8(sp)
    80002ff2:	6105                	addi	sp,sp,32
    80002ff4:	8082                	ret

0000000080002ff6 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002ff6:	1141                	addi	sp,sp,-16
    80002ff8:	e422                	sd	s0,8(sp)
    80002ffa:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002ffc:	411c                	lw	a5,0(a0)
    80002ffe:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003000:	415c                	lw	a5,4(a0)
    80003002:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003004:	04451783          	lh	a5,68(a0)
    80003008:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    8000300c:	04a51783          	lh	a5,74(a0)
    80003010:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003014:	04c56783          	lwu	a5,76(a0)
    80003018:	e99c                	sd	a5,16(a1)
}
    8000301a:	6422                	ld	s0,8(sp)
    8000301c:	0141                	addi	sp,sp,16
    8000301e:	8082                	ret

0000000080003020 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003020:	457c                	lw	a5,76(a0)
    80003022:	0ed7e963          	bltu	a5,a3,80003114 <readi+0xf4>
{
    80003026:	7159                	addi	sp,sp,-112
    80003028:	f486                	sd	ra,104(sp)
    8000302a:	f0a2                	sd	s0,96(sp)
    8000302c:	eca6                	sd	s1,88(sp)
    8000302e:	e8ca                	sd	s2,80(sp)
    80003030:	e4ce                	sd	s3,72(sp)
    80003032:	e0d2                	sd	s4,64(sp)
    80003034:	fc56                	sd	s5,56(sp)
    80003036:	f85a                	sd	s6,48(sp)
    80003038:	f45e                	sd	s7,40(sp)
    8000303a:	f062                	sd	s8,32(sp)
    8000303c:	ec66                	sd	s9,24(sp)
    8000303e:	e86a                	sd	s10,16(sp)
    80003040:	e46e                	sd	s11,8(sp)
    80003042:	1880                	addi	s0,sp,112
    80003044:	8b2a                	mv	s6,a0
    80003046:	8bae                	mv	s7,a1
    80003048:	8a32                	mv	s4,a2
    8000304a:	84b6                	mv	s1,a3
    8000304c:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    8000304e:	9f35                	addw	a4,a4,a3
    return 0;
    80003050:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003052:	0ad76063          	bltu	a4,a3,800030f2 <readi+0xd2>
  if(off + n > ip->size)
    80003056:	00e7f463          	bgeu	a5,a4,8000305e <readi+0x3e>
    n = ip->size - off;
    8000305a:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000305e:	0a0a8963          	beqz	s5,80003110 <readi+0xf0>
    80003062:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003064:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003068:	5c7d                	li	s8,-1
    8000306a:	a82d                	j	800030a4 <readi+0x84>
    8000306c:	020d1d93          	slli	s11,s10,0x20
    80003070:	020ddd93          	srli	s11,s11,0x20
    80003074:	05890613          	addi	a2,s2,88
    80003078:	86ee                	mv	a3,s11
    8000307a:	963a                	add	a2,a2,a4
    8000307c:	85d2                	mv	a1,s4
    8000307e:	855e                	mv	a0,s7
    80003080:	fffff097          	auipc	ra,0xfffff
    80003084:	a34080e7          	jalr	-1484(ra) # 80001ab4 <either_copyout>
    80003088:	05850d63          	beq	a0,s8,800030e2 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    8000308c:	854a                	mv	a0,s2
    8000308e:	fffff097          	auipc	ra,0xfffff
    80003092:	5f4080e7          	jalr	1524(ra) # 80002682 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003096:	013d09bb          	addw	s3,s10,s3
    8000309a:	009d04bb          	addw	s1,s10,s1
    8000309e:	9a6e                	add	s4,s4,s11
    800030a0:	0559f763          	bgeu	s3,s5,800030ee <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    800030a4:	00a4d59b          	srliw	a1,s1,0xa
    800030a8:	855a                	mv	a0,s6
    800030aa:	00000097          	auipc	ra,0x0
    800030ae:	8a2080e7          	jalr	-1886(ra) # 8000294c <bmap>
    800030b2:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800030b6:	cd85                	beqz	a1,800030ee <readi+0xce>
    bp = bread(ip->dev, addr);
    800030b8:	000b2503          	lw	a0,0(s6)
    800030bc:	fffff097          	auipc	ra,0xfffff
    800030c0:	496080e7          	jalr	1174(ra) # 80002552 <bread>
    800030c4:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800030c6:	3ff4f713          	andi	a4,s1,1023
    800030ca:	40ec87bb          	subw	a5,s9,a4
    800030ce:	413a86bb          	subw	a3,s5,s3
    800030d2:	8d3e                	mv	s10,a5
    800030d4:	2781                	sext.w	a5,a5
    800030d6:	0006861b          	sext.w	a2,a3
    800030da:	f8f679e3          	bgeu	a2,a5,8000306c <readi+0x4c>
    800030de:	8d36                	mv	s10,a3
    800030e0:	b771                	j	8000306c <readi+0x4c>
      brelse(bp);
    800030e2:	854a                	mv	a0,s2
    800030e4:	fffff097          	auipc	ra,0xfffff
    800030e8:	59e080e7          	jalr	1438(ra) # 80002682 <brelse>
      tot = -1;
    800030ec:	59fd                	li	s3,-1
  }
  return tot;
    800030ee:	0009851b          	sext.w	a0,s3
}
    800030f2:	70a6                	ld	ra,104(sp)
    800030f4:	7406                	ld	s0,96(sp)
    800030f6:	64e6                	ld	s1,88(sp)
    800030f8:	6946                	ld	s2,80(sp)
    800030fa:	69a6                	ld	s3,72(sp)
    800030fc:	6a06                	ld	s4,64(sp)
    800030fe:	7ae2                	ld	s5,56(sp)
    80003100:	7b42                	ld	s6,48(sp)
    80003102:	7ba2                	ld	s7,40(sp)
    80003104:	7c02                	ld	s8,32(sp)
    80003106:	6ce2                	ld	s9,24(sp)
    80003108:	6d42                	ld	s10,16(sp)
    8000310a:	6da2                	ld	s11,8(sp)
    8000310c:	6165                	addi	sp,sp,112
    8000310e:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003110:	89d6                	mv	s3,s5
    80003112:	bff1                	j	800030ee <readi+0xce>
    return 0;
    80003114:	4501                	li	a0,0
}
    80003116:	8082                	ret

0000000080003118 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003118:	457c                	lw	a5,76(a0)
    8000311a:	10d7e863          	bltu	a5,a3,8000322a <writei+0x112>
{
    8000311e:	7159                	addi	sp,sp,-112
    80003120:	f486                	sd	ra,104(sp)
    80003122:	f0a2                	sd	s0,96(sp)
    80003124:	eca6                	sd	s1,88(sp)
    80003126:	e8ca                	sd	s2,80(sp)
    80003128:	e4ce                	sd	s3,72(sp)
    8000312a:	e0d2                	sd	s4,64(sp)
    8000312c:	fc56                	sd	s5,56(sp)
    8000312e:	f85a                	sd	s6,48(sp)
    80003130:	f45e                	sd	s7,40(sp)
    80003132:	f062                	sd	s8,32(sp)
    80003134:	ec66                	sd	s9,24(sp)
    80003136:	e86a                	sd	s10,16(sp)
    80003138:	e46e                	sd	s11,8(sp)
    8000313a:	1880                	addi	s0,sp,112
    8000313c:	8aaa                	mv	s5,a0
    8000313e:	8bae                	mv	s7,a1
    80003140:	8a32                	mv	s4,a2
    80003142:	8936                	mv	s2,a3
    80003144:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003146:	00e687bb          	addw	a5,a3,a4
    8000314a:	0ed7e263          	bltu	a5,a3,8000322e <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    8000314e:	00043737          	lui	a4,0x43
    80003152:	0ef76063          	bltu	a4,a5,80003232 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003156:	0c0b0863          	beqz	s6,80003226 <writei+0x10e>
    8000315a:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000315c:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003160:	5c7d                	li	s8,-1
    80003162:	a091                	j	800031a6 <writei+0x8e>
    80003164:	020d1d93          	slli	s11,s10,0x20
    80003168:	020ddd93          	srli	s11,s11,0x20
    8000316c:	05848513          	addi	a0,s1,88
    80003170:	86ee                	mv	a3,s11
    80003172:	8652                	mv	a2,s4
    80003174:	85de                	mv	a1,s7
    80003176:	953a                	add	a0,a0,a4
    80003178:	fffff097          	auipc	ra,0xfffff
    8000317c:	992080e7          	jalr	-1646(ra) # 80001b0a <either_copyin>
    80003180:	07850263          	beq	a0,s8,800031e4 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003184:	8526                	mv	a0,s1
    80003186:	00000097          	auipc	ra,0x0
    8000318a:	780080e7          	jalr	1920(ra) # 80003906 <log_write>
    brelse(bp);
    8000318e:	8526                	mv	a0,s1
    80003190:	fffff097          	auipc	ra,0xfffff
    80003194:	4f2080e7          	jalr	1266(ra) # 80002682 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003198:	013d09bb          	addw	s3,s10,s3
    8000319c:	012d093b          	addw	s2,s10,s2
    800031a0:	9a6e                	add	s4,s4,s11
    800031a2:	0569f663          	bgeu	s3,s6,800031ee <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    800031a6:	00a9559b          	srliw	a1,s2,0xa
    800031aa:	8556                	mv	a0,s5
    800031ac:	fffff097          	auipc	ra,0xfffff
    800031b0:	7a0080e7          	jalr	1952(ra) # 8000294c <bmap>
    800031b4:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800031b8:	c99d                	beqz	a1,800031ee <writei+0xd6>
    bp = bread(ip->dev, addr);
    800031ba:	000aa503          	lw	a0,0(s5)
    800031be:	fffff097          	auipc	ra,0xfffff
    800031c2:	394080e7          	jalr	916(ra) # 80002552 <bread>
    800031c6:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800031c8:	3ff97713          	andi	a4,s2,1023
    800031cc:	40ec87bb          	subw	a5,s9,a4
    800031d0:	413b06bb          	subw	a3,s6,s3
    800031d4:	8d3e                	mv	s10,a5
    800031d6:	2781                	sext.w	a5,a5
    800031d8:	0006861b          	sext.w	a2,a3
    800031dc:	f8f674e3          	bgeu	a2,a5,80003164 <writei+0x4c>
    800031e0:	8d36                	mv	s10,a3
    800031e2:	b749                	j	80003164 <writei+0x4c>
      brelse(bp);
    800031e4:	8526                	mv	a0,s1
    800031e6:	fffff097          	auipc	ra,0xfffff
    800031ea:	49c080e7          	jalr	1180(ra) # 80002682 <brelse>
  }

  if(off > ip->size)
    800031ee:	04caa783          	lw	a5,76(s5)
    800031f2:	0127f463          	bgeu	a5,s2,800031fa <writei+0xe2>
    ip->size = off;
    800031f6:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800031fa:	8556                	mv	a0,s5
    800031fc:	00000097          	auipc	ra,0x0
    80003200:	aa6080e7          	jalr	-1370(ra) # 80002ca2 <iupdate>

  return tot;
    80003204:	0009851b          	sext.w	a0,s3
}
    80003208:	70a6                	ld	ra,104(sp)
    8000320a:	7406                	ld	s0,96(sp)
    8000320c:	64e6                	ld	s1,88(sp)
    8000320e:	6946                	ld	s2,80(sp)
    80003210:	69a6                	ld	s3,72(sp)
    80003212:	6a06                	ld	s4,64(sp)
    80003214:	7ae2                	ld	s5,56(sp)
    80003216:	7b42                	ld	s6,48(sp)
    80003218:	7ba2                	ld	s7,40(sp)
    8000321a:	7c02                	ld	s8,32(sp)
    8000321c:	6ce2                	ld	s9,24(sp)
    8000321e:	6d42                	ld	s10,16(sp)
    80003220:	6da2                	ld	s11,8(sp)
    80003222:	6165                	addi	sp,sp,112
    80003224:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003226:	89da                	mv	s3,s6
    80003228:	bfc9                	j	800031fa <writei+0xe2>
    return -1;
    8000322a:	557d                	li	a0,-1
}
    8000322c:	8082                	ret
    return -1;
    8000322e:	557d                	li	a0,-1
    80003230:	bfe1                	j	80003208 <writei+0xf0>
    return -1;
    80003232:	557d                	li	a0,-1
    80003234:	bfd1                	j	80003208 <writei+0xf0>

0000000080003236 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003236:	1141                	addi	sp,sp,-16
    80003238:	e406                	sd	ra,8(sp)
    8000323a:	e022                	sd	s0,0(sp)
    8000323c:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8000323e:	4639                	li	a2,14
    80003240:	ffffd097          	auipc	ra,0xffffd
    80003244:	010080e7          	jalr	16(ra) # 80000250 <strncmp>
}
    80003248:	60a2                	ld	ra,8(sp)
    8000324a:	6402                	ld	s0,0(sp)
    8000324c:	0141                	addi	sp,sp,16
    8000324e:	8082                	ret

0000000080003250 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003250:	7139                	addi	sp,sp,-64
    80003252:	fc06                	sd	ra,56(sp)
    80003254:	f822                	sd	s0,48(sp)
    80003256:	f426                	sd	s1,40(sp)
    80003258:	f04a                	sd	s2,32(sp)
    8000325a:	ec4e                	sd	s3,24(sp)
    8000325c:	e852                	sd	s4,16(sp)
    8000325e:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003260:	04451703          	lh	a4,68(a0)
    80003264:	4785                	li	a5,1
    80003266:	00f71a63          	bne	a4,a5,8000327a <dirlookup+0x2a>
    8000326a:	892a                	mv	s2,a0
    8000326c:	89ae                	mv	s3,a1
    8000326e:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003270:	457c                	lw	a5,76(a0)
    80003272:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003274:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003276:	e79d                	bnez	a5,800032a4 <dirlookup+0x54>
    80003278:	a8a5                	j	800032f0 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    8000327a:	00005517          	auipc	a0,0x5
    8000327e:	39e50513          	addi	a0,a0,926 # 80008618 <syscalls+0x1e8>
    80003282:	00003097          	auipc	ra,0x3
    80003286:	bf0080e7          	jalr	-1040(ra) # 80005e72 <panic>
      panic("dirlookup read");
    8000328a:	00005517          	auipc	a0,0x5
    8000328e:	3a650513          	addi	a0,a0,934 # 80008630 <syscalls+0x200>
    80003292:	00003097          	auipc	ra,0x3
    80003296:	be0080e7          	jalr	-1056(ra) # 80005e72 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000329a:	24c1                	addiw	s1,s1,16
    8000329c:	04c92783          	lw	a5,76(s2)
    800032a0:	04f4f763          	bgeu	s1,a5,800032ee <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032a4:	4741                	li	a4,16
    800032a6:	86a6                	mv	a3,s1
    800032a8:	fc040613          	addi	a2,s0,-64
    800032ac:	4581                	li	a1,0
    800032ae:	854a                	mv	a0,s2
    800032b0:	00000097          	auipc	ra,0x0
    800032b4:	d70080e7          	jalr	-656(ra) # 80003020 <readi>
    800032b8:	47c1                	li	a5,16
    800032ba:	fcf518e3          	bne	a0,a5,8000328a <dirlookup+0x3a>
    if(de.inum == 0)
    800032be:	fc045783          	lhu	a5,-64(s0)
    800032c2:	dfe1                	beqz	a5,8000329a <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800032c4:	fc240593          	addi	a1,s0,-62
    800032c8:	854e                	mv	a0,s3
    800032ca:	00000097          	auipc	ra,0x0
    800032ce:	f6c080e7          	jalr	-148(ra) # 80003236 <namecmp>
    800032d2:	f561                	bnez	a0,8000329a <dirlookup+0x4a>
      if(poff)
    800032d4:	000a0463          	beqz	s4,800032dc <dirlookup+0x8c>
        *poff = off;
    800032d8:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800032dc:	fc045583          	lhu	a1,-64(s0)
    800032e0:	00092503          	lw	a0,0(s2)
    800032e4:	fffff097          	auipc	ra,0xfffff
    800032e8:	750080e7          	jalr	1872(ra) # 80002a34 <iget>
    800032ec:	a011                	j	800032f0 <dirlookup+0xa0>
  return 0;
    800032ee:	4501                	li	a0,0
}
    800032f0:	70e2                	ld	ra,56(sp)
    800032f2:	7442                	ld	s0,48(sp)
    800032f4:	74a2                	ld	s1,40(sp)
    800032f6:	7902                	ld	s2,32(sp)
    800032f8:	69e2                	ld	s3,24(sp)
    800032fa:	6a42                	ld	s4,16(sp)
    800032fc:	6121                	addi	sp,sp,64
    800032fe:	8082                	ret

0000000080003300 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003300:	711d                	addi	sp,sp,-96
    80003302:	ec86                	sd	ra,88(sp)
    80003304:	e8a2                	sd	s0,80(sp)
    80003306:	e4a6                	sd	s1,72(sp)
    80003308:	e0ca                	sd	s2,64(sp)
    8000330a:	fc4e                	sd	s3,56(sp)
    8000330c:	f852                	sd	s4,48(sp)
    8000330e:	f456                	sd	s5,40(sp)
    80003310:	f05a                	sd	s6,32(sp)
    80003312:	ec5e                	sd	s7,24(sp)
    80003314:	e862                	sd	s8,16(sp)
    80003316:	e466                	sd	s9,8(sp)
    80003318:	1080                	addi	s0,sp,96
    8000331a:	84aa                	mv	s1,a0
    8000331c:	8b2e                	mv	s6,a1
    8000331e:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003320:	00054703          	lbu	a4,0(a0)
    80003324:	02f00793          	li	a5,47
    80003328:	02f70363          	beq	a4,a5,8000334e <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000332c:	ffffe097          	auipc	ra,0xffffe
    80003330:	c14080e7          	jalr	-1004(ra) # 80000f40 <myproc>
    80003334:	15053503          	ld	a0,336(a0)
    80003338:	00000097          	auipc	ra,0x0
    8000333c:	9f6080e7          	jalr	-1546(ra) # 80002d2e <idup>
    80003340:	89aa                	mv	s3,a0
  while(*path == '/')
    80003342:	02f00913          	li	s2,47
  len = path - s;
    80003346:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    80003348:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000334a:	4c05                	li	s8,1
    8000334c:	a865                	j	80003404 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    8000334e:	4585                	li	a1,1
    80003350:	4505                	li	a0,1
    80003352:	fffff097          	auipc	ra,0xfffff
    80003356:	6e2080e7          	jalr	1762(ra) # 80002a34 <iget>
    8000335a:	89aa                	mv	s3,a0
    8000335c:	b7dd                	j	80003342 <namex+0x42>
      iunlockput(ip);
    8000335e:	854e                	mv	a0,s3
    80003360:	00000097          	auipc	ra,0x0
    80003364:	c6e080e7          	jalr	-914(ra) # 80002fce <iunlockput>
      return 0;
    80003368:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000336a:	854e                	mv	a0,s3
    8000336c:	60e6                	ld	ra,88(sp)
    8000336e:	6446                	ld	s0,80(sp)
    80003370:	64a6                	ld	s1,72(sp)
    80003372:	6906                	ld	s2,64(sp)
    80003374:	79e2                	ld	s3,56(sp)
    80003376:	7a42                	ld	s4,48(sp)
    80003378:	7aa2                	ld	s5,40(sp)
    8000337a:	7b02                	ld	s6,32(sp)
    8000337c:	6be2                	ld	s7,24(sp)
    8000337e:	6c42                	ld	s8,16(sp)
    80003380:	6ca2                	ld	s9,8(sp)
    80003382:	6125                	addi	sp,sp,96
    80003384:	8082                	ret
      iunlock(ip);
    80003386:	854e                	mv	a0,s3
    80003388:	00000097          	auipc	ra,0x0
    8000338c:	aa6080e7          	jalr	-1370(ra) # 80002e2e <iunlock>
      return ip;
    80003390:	bfe9                	j	8000336a <namex+0x6a>
      iunlockput(ip);
    80003392:	854e                	mv	a0,s3
    80003394:	00000097          	auipc	ra,0x0
    80003398:	c3a080e7          	jalr	-966(ra) # 80002fce <iunlockput>
      return 0;
    8000339c:	89d2                	mv	s3,s4
    8000339e:	b7f1                	j	8000336a <namex+0x6a>
  len = path - s;
    800033a0:	40b48633          	sub	a2,s1,a1
    800033a4:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    800033a8:	094cd463          	bge	s9,s4,80003430 <namex+0x130>
    memmove(name, s, DIRSIZ);
    800033ac:	4639                	li	a2,14
    800033ae:	8556                	mv	a0,s5
    800033b0:	ffffd097          	auipc	ra,0xffffd
    800033b4:	e28080e7          	jalr	-472(ra) # 800001d8 <memmove>
  while(*path == '/')
    800033b8:	0004c783          	lbu	a5,0(s1)
    800033bc:	01279763          	bne	a5,s2,800033ca <namex+0xca>
    path++;
    800033c0:	0485                	addi	s1,s1,1
  while(*path == '/')
    800033c2:	0004c783          	lbu	a5,0(s1)
    800033c6:	ff278de3          	beq	a5,s2,800033c0 <namex+0xc0>
    ilock(ip);
    800033ca:	854e                	mv	a0,s3
    800033cc:	00000097          	auipc	ra,0x0
    800033d0:	9a0080e7          	jalr	-1632(ra) # 80002d6c <ilock>
    if(ip->type != T_DIR){
    800033d4:	04499783          	lh	a5,68(s3)
    800033d8:	f98793e3          	bne	a5,s8,8000335e <namex+0x5e>
    if(nameiparent && *path == '\0'){
    800033dc:	000b0563          	beqz	s6,800033e6 <namex+0xe6>
    800033e0:	0004c783          	lbu	a5,0(s1)
    800033e4:	d3cd                	beqz	a5,80003386 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    800033e6:	865e                	mv	a2,s7
    800033e8:	85d6                	mv	a1,s5
    800033ea:	854e                	mv	a0,s3
    800033ec:	00000097          	auipc	ra,0x0
    800033f0:	e64080e7          	jalr	-412(ra) # 80003250 <dirlookup>
    800033f4:	8a2a                	mv	s4,a0
    800033f6:	dd51                	beqz	a0,80003392 <namex+0x92>
    iunlockput(ip);
    800033f8:	854e                	mv	a0,s3
    800033fa:	00000097          	auipc	ra,0x0
    800033fe:	bd4080e7          	jalr	-1068(ra) # 80002fce <iunlockput>
    ip = next;
    80003402:	89d2                	mv	s3,s4
  while(*path == '/')
    80003404:	0004c783          	lbu	a5,0(s1)
    80003408:	05279763          	bne	a5,s2,80003456 <namex+0x156>
    path++;
    8000340c:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000340e:	0004c783          	lbu	a5,0(s1)
    80003412:	ff278de3          	beq	a5,s2,8000340c <namex+0x10c>
  if(*path == 0)
    80003416:	c79d                	beqz	a5,80003444 <namex+0x144>
    path++;
    80003418:	85a6                	mv	a1,s1
  len = path - s;
    8000341a:	8a5e                	mv	s4,s7
    8000341c:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    8000341e:	01278963          	beq	a5,s2,80003430 <namex+0x130>
    80003422:	dfbd                	beqz	a5,800033a0 <namex+0xa0>
    path++;
    80003424:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80003426:	0004c783          	lbu	a5,0(s1)
    8000342a:	ff279ce3          	bne	a5,s2,80003422 <namex+0x122>
    8000342e:	bf8d                	j	800033a0 <namex+0xa0>
    memmove(name, s, len);
    80003430:	2601                	sext.w	a2,a2
    80003432:	8556                	mv	a0,s5
    80003434:	ffffd097          	auipc	ra,0xffffd
    80003438:	da4080e7          	jalr	-604(ra) # 800001d8 <memmove>
    name[len] = 0;
    8000343c:	9a56                	add	s4,s4,s5
    8000343e:	000a0023          	sb	zero,0(s4)
    80003442:	bf9d                	j	800033b8 <namex+0xb8>
  if(nameiparent){
    80003444:	f20b03e3          	beqz	s6,8000336a <namex+0x6a>
    iput(ip);
    80003448:	854e                	mv	a0,s3
    8000344a:	00000097          	auipc	ra,0x0
    8000344e:	adc080e7          	jalr	-1316(ra) # 80002f26 <iput>
    return 0;
    80003452:	4981                	li	s3,0
    80003454:	bf19                	j	8000336a <namex+0x6a>
  if(*path == 0)
    80003456:	d7fd                	beqz	a5,80003444 <namex+0x144>
  while(*path != '/' && *path != 0)
    80003458:	0004c783          	lbu	a5,0(s1)
    8000345c:	85a6                	mv	a1,s1
    8000345e:	b7d1                	j	80003422 <namex+0x122>

0000000080003460 <dirlink>:
{
    80003460:	7139                	addi	sp,sp,-64
    80003462:	fc06                	sd	ra,56(sp)
    80003464:	f822                	sd	s0,48(sp)
    80003466:	f426                	sd	s1,40(sp)
    80003468:	f04a                	sd	s2,32(sp)
    8000346a:	ec4e                	sd	s3,24(sp)
    8000346c:	e852                	sd	s4,16(sp)
    8000346e:	0080                	addi	s0,sp,64
    80003470:	892a                	mv	s2,a0
    80003472:	8a2e                	mv	s4,a1
    80003474:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003476:	4601                	li	a2,0
    80003478:	00000097          	auipc	ra,0x0
    8000347c:	dd8080e7          	jalr	-552(ra) # 80003250 <dirlookup>
    80003480:	e93d                	bnez	a0,800034f6 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003482:	04c92483          	lw	s1,76(s2)
    80003486:	c49d                	beqz	s1,800034b4 <dirlink+0x54>
    80003488:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000348a:	4741                	li	a4,16
    8000348c:	86a6                	mv	a3,s1
    8000348e:	fc040613          	addi	a2,s0,-64
    80003492:	4581                	li	a1,0
    80003494:	854a                	mv	a0,s2
    80003496:	00000097          	auipc	ra,0x0
    8000349a:	b8a080e7          	jalr	-1142(ra) # 80003020 <readi>
    8000349e:	47c1                	li	a5,16
    800034a0:	06f51163          	bne	a0,a5,80003502 <dirlink+0xa2>
    if(de.inum == 0)
    800034a4:	fc045783          	lhu	a5,-64(s0)
    800034a8:	c791                	beqz	a5,800034b4 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800034aa:	24c1                	addiw	s1,s1,16
    800034ac:	04c92783          	lw	a5,76(s2)
    800034b0:	fcf4ede3          	bltu	s1,a5,8000348a <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800034b4:	4639                	li	a2,14
    800034b6:	85d2                	mv	a1,s4
    800034b8:	fc240513          	addi	a0,s0,-62
    800034bc:	ffffd097          	auipc	ra,0xffffd
    800034c0:	dd0080e7          	jalr	-560(ra) # 8000028c <strncpy>
  de.inum = inum;
    800034c4:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800034c8:	4741                	li	a4,16
    800034ca:	86a6                	mv	a3,s1
    800034cc:	fc040613          	addi	a2,s0,-64
    800034d0:	4581                	li	a1,0
    800034d2:	854a                	mv	a0,s2
    800034d4:	00000097          	auipc	ra,0x0
    800034d8:	c44080e7          	jalr	-956(ra) # 80003118 <writei>
    800034dc:	1541                	addi	a0,a0,-16
    800034de:	00a03533          	snez	a0,a0
    800034e2:	40a00533          	neg	a0,a0
}
    800034e6:	70e2                	ld	ra,56(sp)
    800034e8:	7442                	ld	s0,48(sp)
    800034ea:	74a2                	ld	s1,40(sp)
    800034ec:	7902                	ld	s2,32(sp)
    800034ee:	69e2                	ld	s3,24(sp)
    800034f0:	6a42                	ld	s4,16(sp)
    800034f2:	6121                	addi	sp,sp,64
    800034f4:	8082                	ret
    iput(ip);
    800034f6:	00000097          	auipc	ra,0x0
    800034fa:	a30080e7          	jalr	-1488(ra) # 80002f26 <iput>
    return -1;
    800034fe:	557d                	li	a0,-1
    80003500:	b7dd                	j	800034e6 <dirlink+0x86>
      panic("dirlink read");
    80003502:	00005517          	auipc	a0,0x5
    80003506:	13e50513          	addi	a0,a0,318 # 80008640 <syscalls+0x210>
    8000350a:	00003097          	auipc	ra,0x3
    8000350e:	968080e7          	jalr	-1688(ra) # 80005e72 <panic>

0000000080003512 <namei>:

struct inode*
namei(char *path)
{
    80003512:	1101                	addi	sp,sp,-32
    80003514:	ec06                	sd	ra,24(sp)
    80003516:	e822                	sd	s0,16(sp)
    80003518:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    8000351a:	fe040613          	addi	a2,s0,-32
    8000351e:	4581                	li	a1,0
    80003520:	00000097          	auipc	ra,0x0
    80003524:	de0080e7          	jalr	-544(ra) # 80003300 <namex>
}
    80003528:	60e2                	ld	ra,24(sp)
    8000352a:	6442                	ld	s0,16(sp)
    8000352c:	6105                	addi	sp,sp,32
    8000352e:	8082                	ret

0000000080003530 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003530:	1141                	addi	sp,sp,-16
    80003532:	e406                	sd	ra,8(sp)
    80003534:	e022                	sd	s0,0(sp)
    80003536:	0800                	addi	s0,sp,16
    80003538:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000353a:	4585                	li	a1,1
    8000353c:	00000097          	auipc	ra,0x0
    80003540:	dc4080e7          	jalr	-572(ra) # 80003300 <namex>
}
    80003544:	60a2                	ld	ra,8(sp)
    80003546:	6402                	ld	s0,0(sp)
    80003548:	0141                	addi	sp,sp,16
    8000354a:	8082                	ret

000000008000354c <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000354c:	1101                	addi	sp,sp,-32
    8000354e:	ec06                	sd	ra,24(sp)
    80003550:	e822                	sd	s0,16(sp)
    80003552:	e426                	sd	s1,8(sp)
    80003554:	e04a                	sd	s2,0(sp)
    80003556:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003558:	00015917          	auipc	s2,0x15
    8000355c:	62890913          	addi	s2,s2,1576 # 80018b80 <log>
    80003560:	01892583          	lw	a1,24(s2)
    80003564:	02892503          	lw	a0,40(s2)
    80003568:	fffff097          	auipc	ra,0xfffff
    8000356c:	fea080e7          	jalr	-22(ra) # 80002552 <bread>
    80003570:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003572:	02c92683          	lw	a3,44(s2)
    80003576:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003578:	02d05763          	blez	a3,800035a6 <write_head+0x5a>
    8000357c:	00015797          	auipc	a5,0x15
    80003580:	63478793          	addi	a5,a5,1588 # 80018bb0 <log+0x30>
    80003584:	05c50713          	addi	a4,a0,92
    80003588:	36fd                	addiw	a3,a3,-1
    8000358a:	1682                	slli	a3,a3,0x20
    8000358c:	9281                	srli	a3,a3,0x20
    8000358e:	068a                	slli	a3,a3,0x2
    80003590:	00015617          	auipc	a2,0x15
    80003594:	62460613          	addi	a2,a2,1572 # 80018bb4 <log+0x34>
    80003598:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    8000359a:	4390                	lw	a2,0(a5)
    8000359c:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000359e:	0791                	addi	a5,a5,4
    800035a0:	0711                	addi	a4,a4,4
    800035a2:	fed79ce3          	bne	a5,a3,8000359a <write_head+0x4e>
  }
  bwrite(buf);
    800035a6:	8526                	mv	a0,s1
    800035a8:	fffff097          	auipc	ra,0xfffff
    800035ac:	09c080e7          	jalr	156(ra) # 80002644 <bwrite>
  brelse(buf);
    800035b0:	8526                	mv	a0,s1
    800035b2:	fffff097          	auipc	ra,0xfffff
    800035b6:	0d0080e7          	jalr	208(ra) # 80002682 <brelse>
}
    800035ba:	60e2                	ld	ra,24(sp)
    800035bc:	6442                	ld	s0,16(sp)
    800035be:	64a2                	ld	s1,8(sp)
    800035c0:	6902                	ld	s2,0(sp)
    800035c2:	6105                	addi	sp,sp,32
    800035c4:	8082                	ret

00000000800035c6 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800035c6:	00015797          	auipc	a5,0x15
    800035ca:	5e67a783          	lw	a5,1510(a5) # 80018bac <log+0x2c>
    800035ce:	0af05d63          	blez	a5,80003688 <install_trans+0xc2>
{
    800035d2:	7139                	addi	sp,sp,-64
    800035d4:	fc06                	sd	ra,56(sp)
    800035d6:	f822                	sd	s0,48(sp)
    800035d8:	f426                	sd	s1,40(sp)
    800035da:	f04a                	sd	s2,32(sp)
    800035dc:	ec4e                	sd	s3,24(sp)
    800035de:	e852                	sd	s4,16(sp)
    800035e0:	e456                	sd	s5,8(sp)
    800035e2:	e05a                	sd	s6,0(sp)
    800035e4:	0080                	addi	s0,sp,64
    800035e6:	8b2a                	mv	s6,a0
    800035e8:	00015a97          	auipc	s5,0x15
    800035ec:	5c8a8a93          	addi	s5,s5,1480 # 80018bb0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800035f0:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800035f2:	00015997          	auipc	s3,0x15
    800035f6:	58e98993          	addi	s3,s3,1422 # 80018b80 <log>
    800035fa:	a035                	j	80003626 <install_trans+0x60>
      bunpin(dbuf);
    800035fc:	8526                	mv	a0,s1
    800035fe:	fffff097          	auipc	ra,0xfffff
    80003602:	15e080e7          	jalr	350(ra) # 8000275c <bunpin>
    brelse(lbuf);
    80003606:	854a                	mv	a0,s2
    80003608:	fffff097          	auipc	ra,0xfffff
    8000360c:	07a080e7          	jalr	122(ra) # 80002682 <brelse>
    brelse(dbuf);
    80003610:	8526                	mv	a0,s1
    80003612:	fffff097          	auipc	ra,0xfffff
    80003616:	070080e7          	jalr	112(ra) # 80002682 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000361a:	2a05                	addiw	s4,s4,1
    8000361c:	0a91                	addi	s5,s5,4
    8000361e:	02c9a783          	lw	a5,44(s3)
    80003622:	04fa5963          	bge	s4,a5,80003674 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003626:	0189a583          	lw	a1,24(s3)
    8000362a:	014585bb          	addw	a1,a1,s4
    8000362e:	2585                	addiw	a1,a1,1
    80003630:	0289a503          	lw	a0,40(s3)
    80003634:	fffff097          	auipc	ra,0xfffff
    80003638:	f1e080e7          	jalr	-226(ra) # 80002552 <bread>
    8000363c:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000363e:	000aa583          	lw	a1,0(s5)
    80003642:	0289a503          	lw	a0,40(s3)
    80003646:	fffff097          	auipc	ra,0xfffff
    8000364a:	f0c080e7          	jalr	-244(ra) # 80002552 <bread>
    8000364e:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003650:	40000613          	li	a2,1024
    80003654:	05890593          	addi	a1,s2,88
    80003658:	05850513          	addi	a0,a0,88
    8000365c:	ffffd097          	auipc	ra,0xffffd
    80003660:	b7c080e7          	jalr	-1156(ra) # 800001d8 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003664:	8526                	mv	a0,s1
    80003666:	fffff097          	auipc	ra,0xfffff
    8000366a:	fde080e7          	jalr	-34(ra) # 80002644 <bwrite>
    if(recovering == 0)
    8000366e:	f80b1ce3          	bnez	s6,80003606 <install_trans+0x40>
    80003672:	b769                	j	800035fc <install_trans+0x36>
}
    80003674:	70e2                	ld	ra,56(sp)
    80003676:	7442                	ld	s0,48(sp)
    80003678:	74a2                	ld	s1,40(sp)
    8000367a:	7902                	ld	s2,32(sp)
    8000367c:	69e2                	ld	s3,24(sp)
    8000367e:	6a42                	ld	s4,16(sp)
    80003680:	6aa2                	ld	s5,8(sp)
    80003682:	6b02                	ld	s6,0(sp)
    80003684:	6121                	addi	sp,sp,64
    80003686:	8082                	ret
    80003688:	8082                	ret

000000008000368a <initlog>:
{
    8000368a:	7179                	addi	sp,sp,-48
    8000368c:	f406                	sd	ra,40(sp)
    8000368e:	f022                	sd	s0,32(sp)
    80003690:	ec26                	sd	s1,24(sp)
    80003692:	e84a                	sd	s2,16(sp)
    80003694:	e44e                	sd	s3,8(sp)
    80003696:	1800                	addi	s0,sp,48
    80003698:	892a                	mv	s2,a0
    8000369a:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000369c:	00015497          	auipc	s1,0x15
    800036a0:	4e448493          	addi	s1,s1,1252 # 80018b80 <log>
    800036a4:	00005597          	auipc	a1,0x5
    800036a8:	fac58593          	addi	a1,a1,-84 # 80008650 <syscalls+0x220>
    800036ac:	8526                	mv	a0,s1
    800036ae:	00003097          	auipc	ra,0x3
    800036b2:	c7e080e7          	jalr	-898(ra) # 8000632c <initlock>
  log.start = sb->logstart;
    800036b6:	0149a583          	lw	a1,20(s3)
    800036ba:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800036bc:	0109a783          	lw	a5,16(s3)
    800036c0:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800036c2:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800036c6:	854a                	mv	a0,s2
    800036c8:	fffff097          	auipc	ra,0xfffff
    800036cc:	e8a080e7          	jalr	-374(ra) # 80002552 <bread>
  log.lh.n = lh->n;
    800036d0:	4d3c                	lw	a5,88(a0)
    800036d2:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800036d4:	02f05563          	blez	a5,800036fe <initlog+0x74>
    800036d8:	05c50713          	addi	a4,a0,92
    800036dc:	00015697          	auipc	a3,0x15
    800036e0:	4d468693          	addi	a3,a3,1236 # 80018bb0 <log+0x30>
    800036e4:	37fd                	addiw	a5,a5,-1
    800036e6:	1782                	slli	a5,a5,0x20
    800036e8:	9381                	srli	a5,a5,0x20
    800036ea:	078a                	slli	a5,a5,0x2
    800036ec:	06050613          	addi	a2,a0,96
    800036f0:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    800036f2:	4310                	lw	a2,0(a4)
    800036f4:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    800036f6:	0711                	addi	a4,a4,4
    800036f8:	0691                	addi	a3,a3,4
    800036fa:	fef71ce3          	bne	a4,a5,800036f2 <initlog+0x68>
  brelse(buf);
    800036fe:	fffff097          	auipc	ra,0xfffff
    80003702:	f84080e7          	jalr	-124(ra) # 80002682 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003706:	4505                	li	a0,1
    80003708:	00000097          	auipc	ra,0x0
    8000370c:	ebe080e7          	jalr	-322(ra) # 800035c6 <install_trans>
  log.lh.n = 0;
    80003710:	00015797          	auipc	a5,0x15
    80003714:	4807ae23          	sw	zero,1180(a5) # 80018bac <log+0x2c>
  write_head(); // clear the log
    80003718:	00000097          	auipc	ra,0x0
    8000371c:	e34080e7          	jalr	-460(ra) # 8000354c <write_head>
}
    80003720:	70a2                	ld	ra,40(sp)
    80003722:	7402                	ld	s0,32(sp)
    80003724:	64e2                	ld	s1,24(sp)
    80003726:	6942                	ld	s2,16(sp)
    80003728:	69a2                	ld	s3,8(sp)
    8000372a:	6145                	addi	sp,sp,48
    8000372c:	8082                	ret

000000008000372e <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000372e:	1101                	addi	sp,sp,-32
    80003730:	ec06                	sd	ra,24(sp)
    80003732:	e822                	sd	s0,16(sp)
    80003734:	e426                	sd	s1,8(sp)
    80003736:	e04a                	sd	s2,0(sp)
    80003738:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000373a:	00015517          	auipc	a0,0x15
    8000373e:	44650513          	addi	a0,a0,1094 # 80018b80 <log>
    80003742:	00003097          	auipc	ra,0x3
    80003746:	c7a080e7          	jalr	-902(ra) # 800063bc <acquire>
  while(1){
    if(log.committing){
    8000374a:	00015497          	auipc	s1,0x15
    8000374e:	43648493          	addi	s1,s1,1078 # 80018b80 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003752:	4979                	li	s2,30
    80003754:	a039                	j	80003762 <begin_op+0x34>
      sleep(&log, &log.lock);
    80003756:	85a6                	mv	a1,s1
    80003758:	8526                	mv	a0,s1
    8000375a:	ffffe097          	auipc	ra,0xffffe
    8000375e:	f52080e7          	jalr	-174(ra) # 800016ac <sleep>
    if(log.committing){
    80003762:	50dc                	lw	a5,36(s1)
    80003764:	fbed                	bnez	a5,80003756 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003766:	509c                	lw	a5,32(s1)
    80003768:	0017871b          	addiw	a4,a5,1
    8000376c:	0007069b          	sext.w	a3,a4
    80003770:	0027179b          	slliw	a5,a4,0x2
    80003774:	9fb9                	addw	a5,a5,a4
    80003776:	0017979b          	slliw	a5,a5,0x1
    8000377a:	54d8                	lw	a4,44(s1)
    8000377c:	9fb9                	addw	a5,a5,a4
    8000377e:	00f95963          	bge	s2,a5,80003790 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003782:	85a6                	mv	a1,s1
    80003784:	8526                	mv	a0,s1
    80003786:	ffffe097          	auipc	ra,0xffffe
    8000378a:	f26080e7          	jalr	-218(ra) # 800016ac <sleep>
    8000378e:	bfd1                	j	80003762 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003790:	00015517          	auipc	a0,0x15
    80003794:	3f050513          	addi	a0,a0,1008 # 80018b80 <log>
    80003798:	d114                	sw	a3,32(a0)
      release(&log.lock);
    8000379a:	00003097          	auipc	ra,0x3
    8000379e:	cd6080e7          	jalr	-810(ra) # 80006470 <release>
      break;
    }
  }
}
    800037a2:	60e2                	ld	ra,24(sp)
    800037a4:	6442                	ld	s0,16(sp)
    800037a6:	64a2                	ld	s1,8(sp)
    800037a8:	6902                	ld	s2,0(sp)
    800037aa:	6105                	addi	sp,sp,32
    800037ac:	8082                	ret

00000000800037ae <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800037ae:	7139                	addi	sp,sp,-64
    800037b0:	fc06                	sd	ra,56(sp)
    800037b2:	f822                	sd	s0,48(sp)
    800037b4:	f426                	sd	s1,40(sp)
    800037b6:	f04a                	sd	s2,32(sp)
    800037b8:	ec4e                	sd	s3,24(sp)
    800037ba:	e852                	sd	s4,16(sp)
    800037bc:	e456                	sd	s5,8(sp)
    800037be:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800037c0:	00015497          	auipc	s1,0x15
    800037c4:	3c048493          	addi	s1,s1,960 # 80018b80 <log>
    800037c8:	8526                	mv	a0,s1
    800037ca:	00003097          	auipc	ra,0x3
    800037ce:	bf2080e7          	jalr	-1038(ra) # 800063bc <acquire>
  log.outstanding -= 1;
    800037d2:	509c                	lw	a5,32(s1)
    800037d4:	37fd                	addiw	a5,a5,-1
    800037d6:	0007891b          	sext.w	s2,a5
    800037da:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800037dc:	50dc                	lw	a5,36(s1)
    800037de:	efb9                	bnez	a5,8000383c <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    800037e0:	06091663          	bnez	s2,8000384c <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    800037e4:	00015497          	auipc	s1,0x15
    800037e8:	39c48493          	addi	s1,s1,924 # 80018b80 <log>
    800037ec:	4785                	li	a5,1
    800037ee:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800037f0:	8526                	mv	a0,s1
    800037f2:	00003097          	auipc	ra,0x3
    800037f6:	c7e080e7          	jalr	-898(ra) # 80006470 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800037fa:	54dc                	lw	a5,44(s1)
    800037fc:	06f04763          	bgtz	a5,8000386a <end_op+0xbc>
    acquire(&log.lock);
    80003800:	00015497          	auipc	s1,0x15
    80003804:	38048493          	addi	s1,s1,896 # 80018b80 <log>
    80003808:	8526                	mv	a0,s1
    8000380a:	00003097          	auipc	ra,0x3
    8000380e:	bb2080e7          	jalr	-1102(ra) # 800063bc <acquire>
    log.committing = 0;
    80003812:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003816:	8526                	mv	a0,s1
    80003818:	ffffe097          	auipc	ra,0xffffe
    8000381c:	ef8080e7          	jalr	-264(ra) # 80001710 <wakeup>
    release(&log.lock);
    80003820:	8526                	mv	a0,s1
    80003822:	00003097          	auipc	ra,0x3
    80003826:	c4e080e7          	jalr	-946(ra) # 80006470 <release>
}
    8000382a:	70e2                	ld	ra,56(sp)
    8000382c:	7442                	ld	s0,48(sp)
    8000382e:	74a2                	ld	s1,40(sp)
    80003830:	7902                	ld	s2,32(sp)
    80003832:	69e2                	ld	s3,24(sp)
    80003834:	6a42                	ld	s4,16(sp)
    80003836:	6aa2                	ld	s5,8(sp)
    80003838:	6121                	addi	sp,sp,64
    8000383a:	8082                	ret
    panic("log.committing");
    8000383c:	00005517          	auipc	a0,0x5
    80003840:	e1c50513          	addi	a0,a0,-484 # 80008658 <syscalls+0x228>
    80003844:	00002097          	auipc	ra,0x2
    80003848:	62e080e7          	jalr	1582(ra) # 80005e72 <panic>
    wakeup(&log);
    8000384c:	00015497          	auipc	s1,0x15
    80003850:	33448493          	addi	s1,s1,820 # 80018b80 <log>
    80003854:	8526                	mv	a0,s1
    80003856:	ffffe097          	auipc	ra,0xffffe
    8000385a:	eba080e7          	jalr	-326(ra) # 80001710 <wakeup>
  release(&log.lock);
    8000385e:	8526                	mv	a0,s1
    80003860:	00003097          	auipc	ra,0x3
    80003864:	c10080e7          	jalr	-1008(ra) # 80006470 <release>
  if(do_commit){
    80003868:	b7c9                	j	8000382a <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000386a:	00015a97          	auipc	s5,0x15
    8000386e:	346a8a93          	addi	s5,s5,838 # 80018bb0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003872:	00015a17          	auipc	s4,0x15
    80003876:	30ea0a13          	addi	s4,s4,782 # 80018b80 <log>
    8000387a:	018a2583          	lw	a1,24(s4)
    8000387e:	012585bb          	addw	a1,a1,s2
    80003882:	2585                	addiw	a1,a1,1
    80003884:	028a2503          	lw	a0,40(s4)
    80003888:	fffff097          	auipc	ra,0xfffff
    8000388c:	cca080e7          	jalr	-822(ra) # 80002552 <bread>
    80003890:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003892:	000aa583          	lw	a1,0(s5)
    80003896:	028a2503          	lw	a0,40(s4)
    8000389a:	fffff097          	auipc	ra,0xfffff
    8000389e:	cb8080e7          	jalr	-840(ra) # 80002552 <bread>
    800038a2:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800038a4:	40000613          	li	a2,1024
    800038a8:	05850593          	addi	a1,a0,88
    800038ac:	05848513          	addi	a0,s1,88
    800038b0:	ffffd097          	auipc	ra,0xffffd
    800038b4:	928080e7          	jalr	-1752(ra) # 800001d8 <memmove>
    bwrite(to);  // write the log
    800038b8:	8526                	mv	a0,s1
    800038ba:	fffff097          	auipc	ra,0xfffff
    800038be:	d8a080e7          	jalr	-630(ra) # 80002644 <bwrite>
    brelse(from);
    800038c2:	854e                	mv	a0,s3
    800038c4:	fffff097          	auipc	ra,0xfffff
    800038c8:	dbe080e7          	jalr	-578(ra) # 80002682 <brelse>
    brelse(to);
    800038cc:	8526                	mv	a0,s1
    800038ce:	fffff097          	auipc	ra,0xfffff
    800038d2:	db4080e7          	jalr	-588(ra) # 80002682 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800038d6:	2905                	addiw	s2,s2,1
    800038d8:	0a91                	addi	s5,s5,4
    800038da:	02ca2783          	lw	a5,44(s4)
    800038de:	f8f94ee3          	blt	s2,a5,8000387a <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800038e2:	00000097          	auipc	ra,0x0
    800038e6:	c6a080e7          	jalr	-918(ra) # 8000354c <write_head>
    install_trans(0); // Now install writes to home locations
    800038ea:	4501                	li	a0,0
    800038ec:	00000097          	auipc	ra,0x0
    800038f0:	cda080e7          	jalr	-806(ra) # 800035c6 <install_trans>
    log.lh.n = 0;
    800038f4:	00015797          	auipc	a5,0x15
    800038f8:	2a07ac23          	sw	zero,696(a5) # 80018bac <log+0x2c>
    write_head();    // Erase the transaction from the log
    800038fc:	00000097          	auipc	ra,0x0
    80003900:	c50080e7          	jalr	-944(ra) # 8000354c <write_head>
    80003904:	bdf5                	j	80003800 <end_op+0x52>

0000000080003906 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003906:	1101                	addi	sp,sp,-32
    80003908:	ec06                	sd	ra,24(sp)
    8000390a:	e822                	sd	s0,16(sp)
    8000390c:	e426                	sd	s1,8(sp)
    8000390e:	e04a                	sd	s2,0(sp)
    80003910:	1000                	addi	s0,sp,32
    80003912:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003914:	00015917          	auipc	s2,0x15
    80003918:	26c90913          	addi	s2,s2,620 # 80018b80 <log>
    8000391c:	854a                	mv	a0,s2
    8000391e:	00003097          	auipc	ra,0x3
    80003922:	a9e080e7          	jalr	-1378(ra) # 800063bc <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003926:	02c92603          	lw	a2,44(s2)
    8000392a:	47f5                	li	a5,29
    8000392c:	06c7c563          	blt	a5,a2,80003996 <log_write+0x90>
    80003930:	00015797          	auipc	a5,0x15
    80003934:	26c7a783          	lw	a5,620(a5) # 80018b9c <log+0x1c>
    80003938:	37fd                	addiw	a5,a5,-1
    8000393a:	04f65e63          	bge	a2,a5,80003996 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000393e:	00015797          	auipc	a5,0x15
    80003942:	2627a783          	lw	a5,610(a5) # 80018ba0 <log+0x20>
    80003946:	06f05063          	blez	a5,800039a6 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    8000394a:	4781                	li	a5,0
    8000394c:	06c05563          	blez	a2,800039b6 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003950:	44cc                	lw	a1,12(s1)
    80003952:	00015717          	auipc	a4,0x15
    80003956:	25e70713          	addi	a4,a4,606 # 80018bb0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    8000395a:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000395c:	4314                	lw	a3,0(a4)
    8000395e:	04b68c63          	beq	a3,a1,800039b6 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003962:	2785                	addiw	a5,a5,1
    80003964:	0711                	addi	a4,a4,4
    80003966:	fef61be3          	bne	a2,a5,8000395c <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000396a:	0621                	addi	a2,a2,8
    8000396c:	060a                	slli	a2,a2,0x2
    8000396e:	00015797          	auipc	a5,0x15
    80003972:	21278793          	addi	a5,a5,530 # 80018b80 <log>
    80003976:	963e                	add	a2,a2,a5
    80003978:	44dc                	lw	a5,12(s1)
    8000397a:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000397c:	8526                	mv	a0,s1
    8000397e:	fffff097          	auipc	ra,0xfffff
    80003982:	da2080e7          	jalr	-606(ra) # 80002720 <bpin>
    log.lh.n++;
    80003986:	00015717          	auipc	a4,0x15
    8000398a:	1fa70713          	addi	a4,a4,506 # 80018b80 <log>
    8000398e:	575c                	lw	a5,44(a4)
    80003990:	2785                	addiw	a5,a5,1
    80003992:	d75c                	sw	a5,44(a4)
    80003994:	a835                	j	800039d0 <log_write+0xca>
    panic("too big a transaction");
    80003996:	00005517          	auipc	a0,0x5
    8000399a:	cd250513          	addi	a0,a0,-814 # 80008668 <syscalls+0x238>
    8000399e:	00002097          	auipc	ra,0x2
    800039a2:	4d4080e7          	jalr	1236(ra) # 80005e72 <panic>
    panic("log_write outside of trans");
    800039a6:	00005517          	auipc	a0,0x5
    800039aa:	cda50513          	addi	a0,a0,-806 # 80008680 <syscalls+0x250>
    800039ae:	00002097          	auipc	ra,0x2
    800039b2:	4c4080e7          	jalr	1220(ra) # 80005e72 <panic>
  log.lh.block[i] = b->blockno;
    800039b6:	00878713          	addi	a4,a5,8
    800039ba:	00271693          	slli	a3,a4,0x2
    800039be:	00015717          	auipc	a4,0x15
    800039c2:	1c270713          	addi	a4,a4,450 # 80018b80 <log>
    800039c6:	9736                	add	a4,a4,a3
    800039c8:	44d4                	lw	a3,12(s1)
    800039ca:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800039cc:	faf608e3          	beq	a2,a5,8000397c <log_write+0x76>
  }
  release(&log.lock);
    800039d0:	00015517          	auipc	a0,0x15
    800039d4:	1b050513          	addi	a0,a0,432 # 80018b80 <log>
    800039d8:	00003097          	auipc	ra,0x3
    800039dc:	a98080e7          	jalr	-1384(ra) # 80006470 <release>
}
    800039e0:	60e2                	ld	ra,24(sp)
    800039e2:	6442                	ld	s0,16(sp)
    800039e4:	64a2                	ld	s1,8(sp)
    800039e6:	6902                	ld	s2,0(sp)
    800039e8:	6105                	addi	sp,sp,32
    800039ea:	8082                	ret

00000000800039ec <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800039ec:	1101                	addi	sp,sp,-32
    800039ee:	ec06                	sd	ra,24(sp)
    800039f0:	e822                	sd	s0,16(sp)
    800039f2:	e426                	sd	s1,8(sp)
    800039f4:	e04a                	sd	s2,0(sp)
    800039f6:	1000                	addi	s0,sp,32
    800039f8:	84aa                	mv	s1,a0
    800039fa:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800039fc:	00005597          	auipc	a1,0x5
    80003a00:	ca458593          	addi	a1,a1,-860 # 800086a0 <syscalls+0x270>
    80003a04:	0521                	addi	a0,a0,8
    80003a06:	00003097          	auipc	ra,0x3
    80003a0a:	926080e7          	jalr	-1754(ra) # 8000632c <initlock>
  lk->name = name;
    80003a0e:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003a12:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003a16:	0204a423          	sw	zero,40(s1)
}
    80003a1a:	60e2                	ld	ra,24(sp)
    80003a1c:	6442                	ld	s0,16(sp)
    80003a1e:	64a2                	ld	s1,8(sp)
    80003a20:	6902                	ld	s2,0(sp)
    80003a22:	6105                	addi	sp,sp,32
    80003a24:	8082                	ret

0000000080003a26 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003a26:	1101                	addi	sp,sp,-32
    80003a28:	ec06                	sd	ra,24(sp)
    80003a2a:	e822                	sd	s0,16(sp)
    80003a2c:	e426                	sd	s1,8(sp)
    80003a2e:	e04a                	sd	s2,0(sp)
    80003a30:	1000                	addi	s0,sp,32
    80003a32:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003a34:	00850913          	addi	s2,a0,8
    80003a38:	854a                	mv	a0,s2
    80003a3a:	00003097          	auipc	ra,0x3
    80003a3e:	982080e7          	jalr	-1662(ra) # 800063bc <acquire>
  while (lk->locked) {
    80003a42:	409c                	lw	a5,0(s1)
    80003a44:	cb89                	beqz	a5,80003a56 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003a46:	85ca                	mv	a1,s2
    80003a48:	8526                	mv	a0,s1
    80003a4a:	ffffe097          	auipc	ra,0xffffe
    80003a4e:	c62080e7          	jalr	-926(ra) # 800016ac <sleep>
  while (lk->locked) {
    80003a52:	409c                	lw	a5,0(s1)
    80003a54:	fbed                	bnez	a5,80003a46 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003a56:	4785                	li	a5,1
    80003a58:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003a5a:	ffffd097          	auipc	ra,0xffffd
    80003a5e:	4e6080e7          	jalr	1254(ra) # 80000f40 <myproc>
    80003a62:	591c                	lw	a5,48(a0)
    80003a64:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003a66:	854a                	mv	a0,s2
    80003a68:	00003097          	auipc	ra,0x3
    80003a6c:	a08080e7          	jalr	-1528(ra) # 80006470 <release>
}
    80003a70:	60e2                	ld	ra,24(sp)
    80003a72:	6442                	ld	s0,16(sp)
    80003a74:	64a2                	ld	s1,8(sp)
    80003a76:	6902                	ld	s2,0(sp)
    80003a78:	6105                	addi	sp,sp,32
    80003a7a:	8082                	ret

0000000080003a7c <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003a7c:	1101                	addi	sp,sp,-32
    80003a7e:	ec06                	sd	ra,24(sp)
    80003a80:	e822                	sd	s0,16(sp)
    80003a82:	e426                	sd	s1,8(sp)
    80003a84:	e04a                	sd	s2,0(sp)
    80003a86:	1000                	addi	s0,sp,32
    80003a88:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003a8a:	00850913          	addi	s2,a0,8
    80003a8e:	854a                	mv	a0,s2
    80003a90:	00003097          	auipc	ra,0x3
    80003a94:	92c080e7          	jalr	-1748(ra) # 800063bc <acquire>
  lk->locked = 0;
    80003a98:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003a9c:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003aa0:	8526                	mv	a0,s1
    80003aa2:	ffffe097          	auipc	ra,0xffffe
    80003aa6:	c6e080e7          	jalr	-914(ra) # 80001710 <wakeup>
  release(&lk->lk);
    80003aaa:	854a                	mv	a0,s2
    80003aac:	00003097          	auipc	ra,0x3
    80003ab0:	9c4080e7          	jalr	-1596(ra) # 80006470 <release>
}
    80003ab4:	60e2                	ld	ra,24(sp)
    80003ab6:	6442                	ld	s0,16(sp)
    80003ab8:	64a2                	ld	s1,8(sp)
    80003aba:	6902                	ld	s2,0(sp)
    80003abc:	6105                	addi	sp,sp,32
    80003abe:	8082                	ret

0000000080003ac0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003ac0:	7179                	addi	sp,sp,-48
    80003ac2:	f406                	sd	ra,40(sp)
    80003ac4:	f022                	sd	s0,32(sp)
    80003ac6:	ec26                	sd	s1,24(sp)
    80003ac8:	e84a                	sd	s2,16(sp)
    80003aca:	e44e                	sd	s3,8(sp)
    80003acc:	1800                	addi	s0,sp,48
    80003ace:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003ad0:	00850913          	addi	s2,a0,8
    80003ad4:	854a                	mv	a0,s2
    80003ad6:	00003097          	auipc	ra,0x3
    80003ada:	8e6080e7          	jalr	-1818(ra) # 800063bc <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003ade:	409c                	lw	a5,0(s1)
    80003ae0:	ef99                	bnez	a5,80003afe <holdingsleep+0x3e>
    80003ae2:	4481                	li	s1,0
  release(&lk->lk);
    80003ae4:	854a                	mv	a0,s2
    80003ae6:	00003097          	auipc	ra,0x3
    80003aea:	98a080e7          	jalr	-1654(ra) # 80006470 <release>
  return r;
}
    80003aee:	8526                	mv	a0,s1
    80003af0:	70a2                	ld	ra,40(sp)
    80003af2:	7402                	ld	s0,32(sp)
    80003af4:	64e2                	ld	s1,24(sp)
    80003af6:	6942                	ld	s2,16(sp)
    80003af8:	69a2                	ld	s3,8(sp)
    80003afa:	6145                	addi	sp,sp,48
    80003afc:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003afe:	0284a983          	lw	s3,40(s1)
    80003b02:	ffffd097          	auipc	ra,0xffffd
    80003b06:	43e080e7          	jalr	1086(ra) # 80000f40 <myproc>
    80003b0a:	5904                	lw	s1,48(a0)
    80003b0c:	413484b3          	sub	s1,s1,s3
    80003b10:	0014b493          	seqz	s1,s1
    80003b14:	bfc1                	j	80003ae4 <holdingsleep+0x24>

0000000080003b16 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003b16:	1141                	addi	sp,sp,-16
    80003b18:	e406                	sd	ra,8(sp)
    80003b1a:	e022                	sd	s0,0(sp)
    80003b1c:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003b1e:	00005597          	auipc	a1,0x5
    80003b22:	b9258593          	addi	a1,a1,-1134 # 800086b0 <syscalls+0x280>
    80003b26:	00015517          	auipc	a0,0x15
    80003b2a:	1a250513          	addi	a0,a0,418 # 80018cc8 <ftable>
    80003b2e:	00002097          	auipc	ra,0x2
    80003b32:	7fe080e7          	jalr	2046(ra) # 8000632c <initlock>
}
    80003b36:	60a2                	ld	ra,8(sp)
    80003b38:	6402                	ld	s0,0(sp)
    80003b3a:	0141                	addi	sp,sp,16
    80003b3c:	8082                	ret

0000000080003b3e <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003b3e:	1101                	addi	sp,sp,-32
    80003b40:	ec06                	sd	ra,24(sp)
    80003b42:	e822                	sd	s0,16(sp)
    80003b44:	e426                	sd	s1,8(sp)
    80003b46:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003b48:	00015517          	auipc	a0,0x15
    80003b4c:	18050513          	addi	a0,a0,384 # 80018cc8 <ftable>
    80003b50:	00003097          	auipc	ra,0x3
    80003b54:	86c080e7          	jalr	-1940(ra) # 800063bc <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b58:	00015497          	auipc	s1,0x15
    80003b5c:	18848493          	addi	s1,s1,392 # 80018ce0 <ftable+0x18>
    80003b60:	00016717          	auipc	a4,0x16
    80003b64:	12070713          	addi	a4,a4,288 # 80019c80 <disk>
    if(f->ref == 0){
    80003b68:	40dc                	lw	a5,4(s1)
    80003b6a:	cf99                	beqz	a5,80003b88 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b6c:	02848493          	addi	s1,s1,40
    80003b70:	fee49ce3          	bne	s1,a4,80003b68 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003b74:	00015517          	auipc	a0,0x15
    80003b78:	15450513          	addi	a0,a0,340 # 80018cc8 <ftable>
    80003b7c:	00003097          	auipc	ra,0x3
    80003b80:	8f4080e7          	jalr	-1804(ra) # 80006470 <release>
  return 0;
    80003b84:	4481                	li	s1,0
    80003b86:	a819                	j	80003b9c <filealloc+0x5e>
      f->ref = 1;
    80003b88:	4785                	li	a5,1
    80003b8a:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003b8c:	00015517          	auipc	a0,0x15
    80003b90:	13c50513          	addi	a0,a0,316 # 80018cc8 <ftable>
    80003b94:	00003097          	auipc	ra,0x3
    80003b98:	8dc080e7          	jalr	-1828(ra) # 80006470 <release>
}
    80003b9c:	8526                	mv	a0,s1
    80003b9e:	60e2                	ld	ra,24(sp)
    80003ba0:	6442                	ld	s0,16(sp)
    80003ba2:	64a2                	ld	s1,8(sp)
    80003ba4:	6105                	addi	sp,sp,32
    80003ba6:	8082                	ret

0000000080003ba8 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003ba8:	1101                	addi	sp,sp,-32
    80003baa:	ec06                	sd	ra,24(sp)
    80003bac:	e822                	sd	s0,16(sp)
    80003bae:	e426                	sd	s1,8(sp)
    80003bb0:	1000                	addi	s0,sp,32
    80003bb2:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003bb4:	00015517          	auipc	a0,0x15
    80003bb8:	11450513          	addi	a0,a0,276 # 80018cc8 <ftable>
    80003bbc:	00003097          	auipc	ra,0x3
    80003bc0:	800080e7          	jalr	-2048(ra) # 800063bc <acquire>
  if(f->ref < 1)
    80003bc4:	40dc                	lw	a5,4(s1)
    80003bc6:	02f05263          	blez	a5,80003bea <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003bca:	2785                	addiw	a5,a5,1
    80003bcc:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003bce:	00015517          	auipc	a0,0x15
    80003bd2:	0fa50513          	addi	a0,a0,250 # 80018cc8 <ftable>
    80003bd6:	00003097          	auipc	ra,0x3
    80003bda:	89a080e7          	jalr	-1894(ra) # 80006470 <release>
  return f;
}
    80003bde:	8526                	mv	a0,s1
    80003be0:	60e2                	ld	ra,24(sp)
    80003be2:	6442                	ld	s0,16(sp)
    80003be4:	64a2                	ld	s1,8(sp)
    80003be6:	6105                	addi	sp,sp,32
    80003be8:	8082                	ret
    panic("filedup");
    80003bea:	00005517          	auipc	a0,0x5
    80003bee:	ace50513          	addi	a0,a0,-1330 # 800086b8 <syscalls+0x288>
    80003bf2:	00002097          	auipc	ra,0x2
    80003bf6:	280080e7          	jalr	640(ra) # 80005e72 <panic>

0000000080003bfa <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003bfa:	7139                	addi	sp,sp,-64
    80003bfc:	fc06                	sd	ra,56(sp)
    80003bfe:	f822                	sd	s0,48(sp)
    80003c00:	f426                	sd	s1,40(sp)
    80003c02:	f04a                	sd	s2,32(sp)
    80003c04:	ec4e                	sd	s3,24(sp)
    80003c06:	e852                	sd	s4,16(sp)
    80003c08:	e456                	sd	s5,8(sp)
    80003c0a:	0080                	addi	s0,sp,64
    80003c0c:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003c0e:	00015517          	auipc	a0,0x15
    80003c12:	0ba50513          	addi	a0,a0,186 # 80018cc8 <ftable>
    80003c16:	00002097          	auipc	ra,0x2
    80003c1a:	7a6080e7          	jalr	1958(ra) # 800063bc <acquire>
  if(f->ref < 1)
    80003c1e:	40dc                	lw	a5,4(s1)
    80003c20:	06f05163          	blez	a5,80003c82 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003c24:	37fd                	addiw	a5,a5,-1
    80003c26:	0007871b          	sext.w	a4,a5
    80003c2a:	c0dc                	sw	a5,4(s1)
    80003c2c:	06e04363          	bgtz	a4,80003c92 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003c30:	0004a903          	lw	s2,0(s1)
    80003c34:	0094ca83          	lbu	s5,9(s1)
    80003c38:	0104ba03          	ld	s4,16(s1)
    80003c3c:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003c40:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003c44:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003c48:	00015517          	auipc	a0,0x15
    80003c4c:	08050513          	addi	a0,a0,128 # 80018cc8 <ftable>
    80003c50:	00003097          	auipc	ra,0x3
    80003c54:	820080e7          	jalr	-2016(ra) # 80006470 <release>

  if(ff.type == FD_PIPE){
    80003c58:	4785                	li	a5,1
    80003c5a:	04f90d63          	beq	s2,a5,80003cb4 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003c5e:	3979                	addiw	s2,s2,-2
    80003c60:	4785                	li	a5,1
    80003c62:	0527e063          	bltu	a5,s2,80003ca2 <fileclose+0xa8>
    begin_op();
    80003c66:	00000097          	auipc	ra,0x0
    80003c6a:	ac8080e7          	jalr	-1336(ra) # 8000372e <begin_op>
    iput(ff.ip);
    80003c6e:	854e                	mv	a0,s3
    80003c70:	fffff097          	auipc	ra,0xfffff
    80003c74:	2b6080e7          	jalr	694(ra) # 80002f26 <iput>
    end_op();
    80003c78:	00000097          	auipc	ra,0x0
    80003c7c:	b36080e7          	jalr	-1226(ra) # 800037ae <end_op>
    80003c80:	a00d                	j	80003ca2 <fileclose+0xa8>
    panic("fileclose");
    80003c82:	00005517          	auipc	a0,0x5
    80003c86:	a3e50513          	addi	a0,a0,-1474 # 800086c0 <syscalls+0x290>
    80003c8a:	00002097          	auipc	ra,0x2
    80003c8e:	1e8080e7          	jalr	488(ra) # 80005e72 <panic>
    release(&ftable.lock);
    80003c92:	00015517          	auipc	a0,0x15
    80003c96:	03650513          	addi	a0,a0,54 # 80018cc8 <ftable>
    80003c9a:	00002097          	auipc	ra,0x2
    80003c9e:	7d6080e7          	jalr	2006(ra) # 80006470 <release>
  }
}
    80003ca2:	70e2                	ld	ra,56(sp)
    80003ca4:	7442                	ld	s0,48(sp)
    80003ca6:	74a2                	ld	s1,40(sp)
    80003ca8:	7902                	ld	s2,32(sp)
    80003caa:	69e2                	ld	s3,24(sp)
    80003cac:	6a42                	ld	s4,16(sp)
    80003cae:	6aa2                	ld	s5,8(sp)
    80003cb0:	6121                	addi	sp,sp,64
    80003cb2:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003cb4:	85d6                	mv	a1,s5
    80003cb6:	8552                	mv	a0,s4
    80003cb8:	00000097          	auipc	ra,0x0
    80003cbc:	34c080e7          	jalr	844(ra) # 80004004 <pipeclose>
    80003cc0:	b7cd                	j	80003ca2 <fileclose+0xa8>

0000000080003cc2 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003cc2:	715d                	addi	sp,sp,-80
    80003cc4:	e486                	sd	ra,72(sp)
    80003cc6:	e0a2                	sd	s0,64(sp)
    80003cc8:	fc26                	sd	s1,56(sp)
    80003cca:	f84a                	sd	s2,48(sp)
    80003ccc:	f44e                	sd	s3,40(sp)
    80003cce:	0880                	addi	s0,sp,80
    80003cd0:	84aa                	mv	s1,a0
    80003cd2:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003cd4:	ffffd097          	auipc	ra,0xffffd
    80003cd8:	26c080e7          	jalr	620(ra) # 80000f40 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003cdc:	409c                	lw	a5,0(s1)
    80003cde:	37f9                	addiw	a5,a5,-2
    80003ce0:	4705                	li	a4,1
    80003ce2:	04f76763          	bltu	a4,a5,80003d30 <filestat+0x6e>
    80003ce6:	892a                	mv	s2,a0
    ilock(f->ip);
    80003ce8:	6c88                	ld	a0,24(s1)
    80003cea:	fffff097          	auipc	ra,0xfffff
    80003cee:	082080e7          	jalr	130(ra) # 80002d6c <ilock>
    stati(f->ip, &st);
    80003cf2:	fb840593          	addi	a1,s0,-72
    80003cf6:	6c88                	ld	a0,24(s1)
    80003cf8:	fffff097          	auipc	ra,0xfffff
    80003cfc:	2fe080e7          	jalr	766(ra) # 80002ff6 <stati>
    iunlock(f->ip);
    80003d00:	6c88                	ld	a0,24(s1)
    80003d02:	fffff097          	auipc	ra,0xfffff
    80003d06:	12c080e7          	jalr	300(ra) # 80002e2e <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003d0a:	46e1                	li	a3,24
    80003d0c:	fb840613          	addi	a2,s0,-72
    80003d10:	85ce                	mv	a1,s3
    80003d12:	05093503          	ld	a0,80(s2)
    80003d16:	ffffd097          	auipc	ra,0xffffd
    80003d1a:	e00080e7          	jalr	-512(ra) # 80000b16 <copyout>
    80003d1e:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003d22:	60a6                	ld	ra,72(sp)
    80003d24:	6406                	ld	s0,64(sp)
    80003d26:	74e2                	ld	s1,56(sp)
    80003d28:	7942                	ld	s2,48(sp)
    80003d2a:	79a2                	ld	s3,40(sp)
    80003d2c:	6161                	addi	sp,sp,80
    80003d2e:	8082                	ret
  return -1;
    80003d30:	557d                	li	a0,-1
    80003d32:	bfc5                	j	80003d22 <filestat+0x60>

0000000080003d34 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003d34:	7179                	addi	sp,sp,-48
    80003d36:	f406                	sd	ra,40(sp)
    80003d38:	f022                	sd	s0,32(sp)
    80003d3a:	ec26                	sd	s1,24(sp)
    80003d3c:	e84a                	sd	s2,16(sp)
    80003d3e:	e44e                	sd	s3,8(sp)
    80003d40:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003d42:	00854783          	lbu	a5,8(a0)
    80003d46:	c3d5                	beqz	a5,80003dea <fileread+0xb6>
    80003d48:	84aa                	mv	s1,a0
    80003d4a:	89ae                	mv	s3,a1
    80003d4c:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d4e:	411c                	lw	a5,0(a0)
    80003d50:	4705                	li	a4,1
    80003d52:	04e78963          	beq	a5,a4,80003da4 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d56:	470d                	li	a4,3
    80003d58:	04e78d63          	beq	a5,a4,80003db2 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d5c:	4709                	li	a4,2
    80003d5e:	06e79e63          	bne	a5,a4,80003dda <fileread+0xa6>
    ilock(f->ip);
    80003d62:	6d08                	ld	a0,24(a0)
    80003d64:	fffff097          	auipc	ra,0xfffff
    80003d68:	008080e7          	jalr	8(ra) # 80002d6c <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003d6c:	874a                	mv	a4,s2
    80003d6e:	5094                	lw	a3,32(s1)
    80003d70:	864e                	mv	a2,s3
    80003d72:	4585                	li	a1,1
    80003d74:	6c88                	ld	a0,24(s1)
    80003d76:	fffff097          	auipc	ra,0xfffff
    80003d7a:	2aa080e7          	jalr	682(ra) # 80003020 <readi>
    80003d7e:	892a                	mv	s2,a0
    80003d80:	00a05563          	blez	a0,80003d8a <fileread+0x56>
      f->off += r;
    80003d84:	509c                	lw	a5,32(s1)
    80003d86:	9fa9                	addw	a5,a5,a0
    80003d88:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003d8a:	6c88                	ld	a0,24(s1)
    80003d8c:	fffff097          	auipc	ra,0xfffff
    80003d90:	0a2080e7          	jalr	162(ra) # 80002e2e <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003d94:	854a                	mv	a0,s2
    80003d96:	70a2                	ld	ra,40(sp)
    80003d98:	7402                	ld	s0,32(sp)
    80003d9a:	64e2                	ld	s1,24(sp)
    80003d9c:	6942                	ld	s2,16(sp)
    80003d9e:	69a2                	ld	s3,8(sp)
    80003da0:	6145                	addi	sp,sp,48
    80003da2:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003da4:	6908                	ld	a0,16(a0)
    80003da6:	00000097          	auipc	ra,0x0
    80003daa:	3ce080e7          	jalr	974(ra) # 80004174 <piperead>
    80003dae:	892a                	mv	s2,a0
    80003db0:	b7d5                	j	80003d94 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003db2:	02451783          	lh	a5,36(a0)
    80003db6:	03079693          	slli	a3,a5,0x30
    80003dba:	92c1                	srli	a3,a3,0x30
    80003dbc:	4725                	li	a4,9
    80003dbe:	02d76863          	bltu	a4,a3,80003dee <fileread+0xba>
    80003dc2:	0792                	slli	a5,a5,0x4
    80003dc4:	00015717          	auipc	a4,0x15
    80003dc8:	e6470713          	addi	a4,a4,-412 # 80018c28 <devsw>
    80003dcc:	97ba                	add	a5,a5,a4
    80003dce:	639c                	ld	a5,0(a5)
    80003dd0:	c38d                	beqz	a5,80003df2 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003dd2:	4505                	li	a0,1
    80003dd4:	9782                	jalr	a5
    80003dd6:	892a                	mv	s2,a0
    80003dd8:	bf75                	j	80003d94 <fileread+0x60>
    panic("fileread");
    80003dda:	00005517          	auipc	a0,0x5
    80003dde:	8f650513          	addi	a0,a0,-1802 # 800086d0 <syscalls+0x2a0>
    80003de2:	00002097          	auipc	ra,0x2
    80003de6:	090080e7          	jalr	144(ra) # 80005e72 <panic>
    return -1;
    80003dea:	597d                	li	s2,-1
    80003dec:	b765                	j	80003d94 <fileread+0x60>
      return -1;
    80003dee:	597d                	li	s2,-1
    80003df0:	b755                	j	80003d94 <fileread+0x60>
    80003df2:	597d                	li	s2,-1
    80003df4:	b745                	j	80003d94 <fileread+0x60>

0000000080003df6 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003df6:	715d                	addi	sp,sp,-80
    80003df8:	e486                	sd	ra,72(sp)
    80003dfa:	e0a2                	sd	s0,64(sp)
    80003dfc:	fc26                	sd	s1,56(sp)
    80003dfe:	f84a                	sd	s2,48(sp)
    80003e00:	f44e                	sd	s3,40(sp)
    80003e02:	f052                	sd	s4,32(sp)
    80003e04:	ec56                	sd	s5,24(sp)
    80003e06:	e85a                	sd	s6,16(sp)
    80003e08:	e45e                	sd	s7,8(sp)
    80003e0a:	e062                	sd	s8,0(sp)
    80003e0c:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003e0e:	00954783          	lbu	a5,9(a0)
    80003e12:	10078663          	beqz	a5,80003f1e <filewrite+0x128>
    80003e16:	892a                	mv	s2,a0
    80003e18:	8aae                	mv	s5,a1
    80003e1a:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003e1c:	411c                	lw	a5,0(a0)
    80003e1e:	4705                	li	a4,1
    80003e20:	02e78263          	beq	a5,a4,80003e44 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003e24:	470d                	li	a4,3
    80003e26:	02e78663          	beq	a5,a4,80003e52 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003e2a:	4709                	li	a4,2
    80003e2c:	0ee79163          	bne	a5,a4,80003f0e <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003e30:	0ac05d63          	blez	a2,80003eea <filewrite+0xf4>
    int i = 0;
    80003e34:	4981                	li	s3,0
    80003e36:	6b05                	lui	s6,0x1
    80003e38:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003e3c:	6b85                	lui	s7,0x1
    80003e3e:	c00b8b9b          	addiw	s7,s7,-1024
    80003e42:	a861                	j	80003eda <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003e44:	6908                	ld	a0,16(a0)
    80003e46:	00000097          	auipc	ra,0x0
    80003e4a:	22e080e7          	jalr	558(ra) # 80004074 <pipewrite>
    80003e4e:	8a2a                	mv	s4,a0
    80003e50:	a045                	j	80003ef0 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003e52:	02451783          	lh	a5,36(a0)
    80003e56:	03079693          	slli	a3,a5,0x30
    80003e5a:	92c1                	srli	a3,a3,0x30
    80003e5c:	4725                	li	a4,9
    80003e5e:	0cd76263          	bltu	a4,a3,80003f22 <filewrite+0x12c>
    80003e62:	0792                	slli	a5,a5,0x4
    80003e64:	00015717          	auipc	a4,0x15
    80003e68:	dc470713          	addi	a4,a4,-572 # 80018c28 <devsw>
    80003e6c:	97ba                	add	a5,a5,a4
    80003e6e:	679c                	ld	a5,8(a5)
    80003e70:	cbdd                	beqz	a5,80003f26 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003e72:	4505                	li	a0,1
    80003e74:	9782                	jalr	a5
    80003e76:	8a2a                	mv	s4,a0
    80003e78:	a8a5                	j	80003ef0 <filewrite+0xfa>
    80003e7a:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003e7e:	00000097          	auipc	ra,0x0
    80003e82:	8b0080e7          	jalr	-1872(ra) # 8000372e <begin_op>
      ilock(f->ip);
    80003e86:	01893503          	ld	a0,24(s2)
    80003e8a:	fffff097          	auipc	ra,0xfffff
    80003e8e:	ee2080e7          	jalr	-286(ra) # 80002d6c <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003e92:	8762                	mv	a4,s8
    80003e94:	02092683          	lw	a3,32(s2)
    80003e98:	01598633          	add	a2,s3,s5
    80003e9c:	4585                	li	a1,1
    80003e9e:	01893503          	ld	a0,24(s2)
    80003ea2:	fffff097          	auipc	ra,0xfffff
    80003ea6:	276080e7          	jalr	630(ra) # 80003118 <writei>
    80003eaa:	84aa                	mv	s1,a0
    80003eac:	00a05763          	blez	a0,80003eba <filewrite+0xc4>
        f->off += r;
    80003eb0:	02092783          	lw	a5,32(s2)
    80003eb4:	9fa9                	addw	a5,a5,a0
    80003eb6:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003eba:	01893503          	ld	a0,24(s2)
    80003ebe:	fffff097          	auipc	ra,0xfffff
    80003ec2:	f70080e7          	jalr	-144(ra) # 80002e2e <iunlock>
      end_op();
    80003ec6:	00000097          	auipc	ra,0x0
    80003eca:	8e8080e7          	jalr	-1816(ra) # 800037ae <end_op>

      if(r != n1){
    80003ece:	009c1f63          	bne	s8,s1,80003eec <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003ed2:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003ed6:	0149db63          	bge	s3,s4,80003eec <filewrite+0xf6>
      int n1 = n - i;
    80003eda:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003ede:	84be                	mv	s1,a5
    80003ee0:	2781                	sext.w	a5,a5
    80003ee2:	f8fb5ce3          	bge	s6,a5,80003e7a <filewrite+0x84>
    80003ee6:	84de                	mv	s1,s7
    80003ee8:	bf49                	j	80003e7a <filewrite+0x84>
    int i = 0;
    80003eea:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003eec:	013a1f63          	bne	s4,s3,80003f0a <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003ef0:	8552                	mv	a0,s4
    80003ef2:	60a6                	ld	ra,72(sp)
    80003ef4:	6406                	ld	s0,64(sp)
    80003ef6:	74e2                	ld	s1,56(sp)
    80003ef8:	7942                	ld	s2,48(sp)
    80003efa:	79a2                	ld	s3,40(sp)
    80003efc:	7a02                	ld	s4,32(sp)
    80003efe:	6ae2                	ld	s5,24(sp)
    80003f00:	6b42                	ld	s6,16(sp)
    80003f02:	6ba2                	ld	s7,8(sp)
    80003f04:	6c02                	ld	s8,0(sp)
    80003f06:	6161                	addi	sp,sp,80
    80003f08:	8082                	ret
    ret = (i == n ? n : -1);
    80003f0a:	5a7d                	li	s4,-1
    80003f0c:	b7d5                	j	80003ef0 <filewrite+0xfa>
    panic("filewrite");
    80003f0e:	00004517          	auipc	a0,0x4
    80003f12:	7d250513          	addi	a0,a0,2002 # 800086e0 <syscalls+0x2b0>
    80003f16:	00002097          	auipc	ra,0x2
    80003f1a:	f5c080e7          	jalr	-164(ra) # 80005e72 <panic>
    return -1;
    80003f1e:	5a7d                	li	s4,-1
    80003f20:	bfc1                	j	80003ef0 <filewrite+0xfa>
      return -1;
    80003f22:	5a7d                	li	s4,-1
    80003f24:	b7f1                	j	80003ef0 <filewrite+0xfa>
    80003f26:	5a7d                	li	s4,-1
    80003f28:	b7e1                	j	80003ef0 <filewrite+0xfa>

0000000080003f2a <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003f2a:	7179                	addi	sp,sp,-48
    80003f2c:	f406                	sd	ra,40(sp)
    80003f2e:	f022                	sd	s0,32(sp)
    80003f30:	ec26                	sd	s1,24(sp)
    80003f32:	e84a                	sd	s2,16(sp)
    80003f34:	e44e                	sd	s3,8(sp)
    80003f36:	e052                	sd	s4,0(sp)
    80003f38:	1800                	addi	s0,sp,48
    80003f3a:	84aa                	mv	s1,a0
    80003f3c:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003f3e:	0005b023          	sd	zero,0(a1)
    80003f42:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003f46:	00000097          	auipc	ra,0x0
    80003f4a:	bf8080e7          	jalr	-1032(ra) # 80003b3e <filealloc>
    80003f4e:	e088                	sd	a0,0(s1)
    80003f50:	c551                	beqz	a0,80003fdc <pipealloc+0xb2>
    80003f52:	00000097          	auipc	ra,0x0
    80003f56:	bec080e7          	jalr	-1044(ra) # 80003b3e <filealloc>
    80003f5a:	00aa3023          	sd	a0,0(s4)
    80003f5e:	c92d                	beqz	a0,80003fd0 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003f60:	ffffc097          	auipc	ra,0xffffc
    80003f64:	1b8080e7          	jalr	440(ra) # 80000118 <kalloc>
    80003f68:	892a                	mv	s2,a0
    80003f6a:	c125                	beqz	a0,80003fca <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003f6c:	4985                	li	s3,1
    80003f6e:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003f72:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003f76:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003f7a:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003f7e:	00004597          	auipc	a1,0x4
    80003f82:	77258593          	addi	a1,a1,1906 # 800086f0 <syscalls+0x2c0>
    80003f86:	00002097          	auipc	ra,0x2
    80003f8a:	3a6080e7          	jalr	934(ra) # 8000632c <initlock>
  (*f0)->type = FD_PIPE;
    80003f8e:	609c                	ld	a5,0(s1)
    80003f90:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003f94:	609c                	ld	a5,0(s1)
    80003f96:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003f9a:	609c                	ld	a5,0(s1)
    80003f9c:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003fa0:	609c                	ld	a5,0(s1)
    80003fa2:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003fa6:	000a3783          	ld	a5,0(s4)
    80003faa:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003fae:	000a3783          	ld	a5,0(s4)
    80003fb2:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003fb6:	000a3783          	ld	a5,0(s4)
    80003fba:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003fbe:	000a3783          	ld	a5,0(s4)
    80003fc2:	0127b823          	sd	s2,16(a5)
  return 0;
    80003fc6:	4501                	li	a0,0
    80003fc8:	a025                	j	80003ff0 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003fca:	6088                	ld	a0,0(s1)
    80003fcc:	e501                	bnez	a0,80003fd4 <pipealloc+0xaa>
    80003fce:	a039                	j	80003fdc <pipealloc+0xb2>
    80003fd0:	6088                	ld	a0,0(s1)
    80003fd2:	c51d                	beqz	a0,80004000 <pipealloc+0xd6>
    fileclose(*f0);
    80003fd4:	00000097          	auipc	ra,0x0
    80003fd8:	c26080e7          	jalr	-986(ra) # 80003bfa <fileclose>
  if(*f1)
    80003fdc:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003fe0:	557d                	li	a0,-1
  if(*f1)
    80003fe2:	c799                	beqz	a5,80003ff0 <pipealloc+0xc6>
    fileclose(*f1);
    80003fe4:	853e                	mv	a0,a5
    80003fe6:	00000097          	auipc	ra,0x0
    80003fea:	c14080e7          	jalr	-1004(ra) # 80003bfa <fileclose>
  return -1;
    80003fee:	557d                	li	a0,-1
}
    80003ff0:	70a2                	ld	ra,40(sp)
    80003ff2:	7402                	ld	s0,32(sp)
    80003ff4:	64e2                	ld	s1,24(sp)
    80003ff6:	6942                	ld	s2,16(sp)
    80003ff8:	69a2                	ld	s3,8(sp)
    80003ffa:	6a02                	ld	s4,0(sp)
    80003ffc:	6145                	addi	sp,sp,48
    80003ffe:	8082                	ret
  return -1;
    80004000:	557d                	li	a0,-1
    80004002:	b7fd                	j	80003ff0 <pipealloc+0xc6>

0000000080004004 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004004:	1101                	addi	sp,sp,-32
    80004006:	ec06                	sd	ra,24(sp)
    80004008:	e822                	sd	s0,16(sp)
    8000400a:	e426                	sd	s1,8(sp)
    8000400c:	e04a                	sd	s2,0(sp)
    8000400e:	1000                	addi	s0,sp,32
    80004010:	84aa                	mv	s1,a0
    80004012:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004014:	00002097          	auipc	ra,0x2
    80004018:	3a8080e7          	jalr	936(ra) # 800063bc <acquire>
  if(writable){
    8000401c:	02090d63          	beqz	s2,80004056 <pipeclose+0x52>
    pi->writeopen = 0;
    80004020:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004024:	21848513          	addi	a0,s1,536
    80004028:	ffffd097          	auipc	ra,0xffffd
    8000402c:	6e8080e7          	jalr	1768(ra) # 80001710 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004030:	2204b783          	ld	a5,544(s1)
    80004034:	eb95                	bnez	a5,80004068 <pipeclose+0x64>
    release(&pi->lock);
    80004036:	8526                	mv	a0,s1
    80004038:	00002097          	auipc	ra,0x2
    8000403c:	438080e7          	jalr	1080(ra) # 80006470 <release>
    kfree((char*)pi);
    80004040:	8526                	mv	a0,s1
    80004042:	ffffc097          	auipc	ra,0xffffc
    80004046:	fda080e7          	jalr	-38(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    8000404a:	60e2                	ld	ra,24(sp)
    8000404c:	6442                	ld	s0,16(sp)
    8000404e:	64a2                	ld	s1,8(sp)
    80004050:	6902                	ld	s2,0(sp)
    80004052:	6105                	addi	sp,sp,32
    80004054:	8082                	ret
    pi->readopen = 0;
    80004056:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    8000405a:	21c48513          	addi	a0,s1,540
    8000405e:	ffffd097          	auipc	ra,0xffffd
    80004062:	6b2080e7          	jalr	1714(ra) # 80001710 <wakeup>
    80004066:	b7e9                	j	80004030 <pipeclose+0x2c>
    release(&pi->lock);
    80004068:	8526                	mv	a0,s1
    8000406a:	00002097          	auipc	ra,0x2
    8000406e:	406080e7          	jalr	1030(ra) # 80006470 <release>
}
    80004072:	bfe1                	j	8000404a <pipeclose+0x46>

0000000080004074 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004074:	7159                	addi	sp,sp,-112
    80004076:	f486                	sd	ra,104(sp)
    80004078:	f0a2                	sd	s0,96(sp)
    8000407a:	eca6                	sd	s1,88(sp)
    8000407c:	e8ca                	sd	s2,80(sp)
    8000407e:	e4ce                	sd	s3,72(sp)
    80004080:	e0d2                	sd	s4,64(sp)
    80004082:	fc56                	sd	s5,56(sp)
    80004084:	f85a                	sd	s6,48(sp)
    80004086:	f45e                	sd	s7,40(sp)
    80004088:	f062                	sd	s8,32(sp)
    8000408a:	ec66                	sd	s9,24(sp)
    8000408c:	1880                	addi	s0,sp,112
    8000408e:	84aa                	mv	s1,a0
    80004090:	8aae                	mv	s5,a1
    80004092:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004094:	ffffd097          	auipc	ra,0xffffd
    80004098:	eac080e7          	jalr	-340(ra) # 80000f40 <myproc>
    8000409c:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    8000409e:	8526                	mv	a0,s1
    800040a0:	00002097          	auipc	ra,0x2
    800040a4:	31c080e7          	jalr	796(ra) # 800063bc <acquire>
  while(i < n){
    800040a8:	0d405463          	blez	s4,80004170 <pipewrite+0xfc>
    800040ac:	8ba6                	mv	s7,s1
  int i = 0;
    800040ae:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800040b0:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800040b2:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800040b6:	21c48c13          	addi	s8,s1,540
    800040ba:	a08d                	j	8000411c <pipewrite+0xa8>
      release(&pi->lock);
    800040bc:	8526                	mv	a0,s1
    800040be:	00002097          	auipc	ra,0x2
    800040c2:	3b2080e7          	jalr	946(ra) # 80006470 <release>
      return -1;
    800040c6:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800040c8:	854a                	mv	a0,s2
    800040ca:	70a6                	ld	ra,104(sp)
    800040cc:	7406                	ld	s0,96(sp)
    800040ce:	64e6                	ld	s1,88(sp)
    800040d0:	6946                	ld	s2,80(sp)
    800040d2:	69a6                	ld	s3,72(sp)
    800040d4:	6a06                	ld	s4,64(sp)
    800040d6:	7ae2                	ld	s5,56(sp)
    800040d8:	7b42                	ld	s6,48(sp)
    800040da:	7ba2                	ld	s7,40(sp)
    800040dc:	7c02                	ld	s8,32(sp)
    800040de:	6ce2                	ld	s9,24(sp)
    800040e0:	6165                	addi	sp,sp,112
    800040e2:	8082                	ret
      wakeup(&pi->nread);
    800040e4:	8566                	mv	a0,s9
    800040e6:	ffffd097          	auipc	ra,0xffffd
    800040ea:	62a080e7          	jalr	1578(ra) # 80001710 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800040ee:	85de                	mv	a1,s7
    800040f0:	8562                	mv	a0,s8
    800040f2:	ffffd097          	auipc	ra,0xffffd
    800040f6:	5ba080e7          	jalr	1466(ra) # 800016ac <sleep>
    800040fa:	a839                	j	80004118 <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800040fc:	21c4a783          	lw	a5,540(s1)
    80004100:	0017871b          	addiw	a4,a5,1
    80004104:	20e4ae23          	sw	a4,540(s1)
    80004108:	1ff7f793          	andi	a5,a5,511
    8000410c:	97a6                	add	a5,a5,s1
    8000410e:	f9f44703          	lbu	a4,-97(s0)
    80004112:	00e78c23          	sb	a4,24(a5)
      i++;
    80004116:	2905                	addiw	s2,s2,1
  while(i < n){
    80004118:	05495063          	bge	s2,s4,80004158 <pipewrite+0xe4>
    if(pi->readopen == 0 || killed(pr)){
    8000411c:	2204a783          	lw	a5,544(s1)
    80004120:	dfd1                	beqz	a5,800040bc <pipewrite+0x48>
    80004122:	854e                	mv	a0,s3
    80004124:	ffffe097          	auipc	ra,0xffffe
    80004128:	830080e7          	jalr	-2000(ra) # 80001954 <killed>
    8000412c:	f941                	bnez	a0,800040bc <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000412e:	2184a783          	lw	a5,536(s1)
    80004132:	21c4a703          	lw	a4,540(s1)
    80004136:	2007879b          	addiw	a5,a5,512
    8000413a:	faf705e3          	beq	a4,a5,800040e4 <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000413e:	4685                	li	a3,1
    80004140:	01590633          	add	a2,s2,s5
    80004144:	f9f40593          	addi	a1,s0,-97
    80004148:	0509b503          	ld	a0,80(s3)
    8000414c:	ffffd097          	auipc	ra,0xffffd
    80004150:	a56080e7          	jalr	-1450(ra) # 80000ba2 <copyin>
    80004154:	fb6514e3          	bne	a0,s6,800040fc <pipewrite+0x88>
  wakeup(&pi->nread);
    80004158:	21848513          	addi	a0,s1,536
    8000415c:	ffffd097          	auipc	ra,0xffffd
    80004160:	5b4080e7          	jalr	1460(ra) # 80001710 <wakeup>
  release(&pi->lock);
    80004164:	8526                	mv	a0,s1
    80004166:	00002097          	auipc	ra,0x2
    8000416a:	30a080e7          	jalr	778(ra) # 80006470 <release>
  return i;
    8000416e:	bfa9                	j	800040c8 <pipewrite+0x54>
  int i = 0;
    80004170:	4901                	li	s2,0
    80004172:	b7dd                	j	80004158 <pipewrite+0xe4>

0000000080004174 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004174:	715d                	addi	sp,sp,-80
    80004176:	e486                	sd	ra,72(sp)
    80004178:	e0a2                	sd	s0,64(sp)
    8000417a:	fc26                	sd	s1,56(sp)
    8000417c:	f84a                	sd	s2,48(sp)
    8000417e:	f44e                	sd	s3,40(sp)
    80004180:	f052                	sd	s4,32(sp)
    80004182:	ec56                	sd	s5,24(sp)
    80004184:	e85a                	sd	s6,16(sp)
    80004186:	0880                	addi	s0,sp,80
    80004188:	84aa                	mv	s1,a0
    8000418a:	892e                	mv	s2,a1
    8000418c:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000418e:	ffffd097          	auipc	ra,0xffffd
    80004192:	db2080e7          	jalr	-590(ra) # 80000f40 <myproc>
    80004196:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004198:	8b26                	mv	s6,s1
    8000419a:	8526                	mv	a0,s1
    8000419c:	00002097          	auipc	ra,0x2
    800041a0:	220080e7          	jalr	544(ra) # 800063bc <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800041a4:	2184a703          	lw	a4,536(s1)
    800041a8:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800041ac:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800041b0:	02f71763          	bne	a4,a5,800041de <piperead+0x6a>
    800041b4:	2244a783          	lw	a5,548(s1)
    800041b8:	c39d                	beqz	a5,800041de <piperead+0x6a>
    if(killed(pr)){
    800041ba:	8552                	mv	a0,s4
    800041bc:	ffffd097          	auipc	ra,0xffffd
    800041c0:	798080e7          	jalr	1944(ra) # 80001954 <killed>
    800041c4:	e941                	bnez	a0,80004254 <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800041c6:	85da                	mv	a1,s6
    800041c8:	854e                	mv	a0,s3
    800041ca:	ffffd097          	auipc	ra,0xffffd
    800041ce:	4e2080e7          	jalr	1250(ra) # 800016ac <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800041d2:	2184a703          	lw	a4,536(s1)
    800041d6:	21c4a783          	lw	a5,540(s1)
    800041da:	fcf70de3          	beq	a4,a5,800041b4 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800041de:	09505263          	blez	s5,80004262 <piperead+0xee>
    800041e2:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800041e4:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    800041e6:	2184a783          	lw	a5,536(s1)
    800041ea:	21c4a703          	lw	a4,540(s1)
    800041ee:	02f70d63          	beq	a4,a5,80004228 <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800041f2:	0017871b          	addiw	a4,a5,1
    800041f6:	20e4ac23          	sw	a4,536(s1)
    800041fa:	1ff7f793          	andi	a5,a5,511
    800041fe:	97a6                	add	a5,a5,s1
    80004200:	0187c783          	lbu	a5,24(a5)
    80004204:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004208:	4685                	li	a3,1
    8000420a:	fbf40613          	addi	a2,s0,-65
    8000420e:	85ca                	mv	a1,s2
    80004210:	050a3503          	ld	a0,80(s4)
    80004214:	ffffd097          	auipc	ra,0xffffd
    80004218:	902080e7          	jalr	-1790(ra) # 80000b16 <copyout>
    8000421c:	01650663          	beq	a0,s6,80004228 <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004220:	2985                	addiw	s3,s3,1
    80004222:	0905                	addi	s2,s2,1
    80004224:	fd3a91e3          	bne	s5,s3,800041e6 <piperead+0x72>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004228:	21c48513          	addi	a0,s1,540
    8000422c:	ffffd097          	auipc	ra,0xffffd
    80004230:	4e4080e7          	jalr	1252(ra) # 80001710 <wakeup>
  release(&pi->lock);
    80004234:	8526                	mv	a0,s1
    80004236:	00002097          	auipc	ra,0x2
    8000423a:	23a080e7          	jalr	570(ra) # 80006470 <release>
  return i;
}
    8000423e:	854e                	mv	a0,s3
    80004240:	60a6                	ld	ra,72(sp)
    80004242:	6406                	ld	s0,64(sp)
    80004244:	74e2                	ld	s1,56(sp)
    80004246:	7942                	ld	s2,48(sp)
    80004248:	79a2                	ld	s3,40(sp)
    8000424a:	7a02                	ld	s4,32(sp)
    8000424c:	6ae2                	ld	s5,24(sp)
    8000424e:	6b42                	ld	s6,16(sp)
    80004250:	6161                	addi	sp,sp,80
    80004252:	8082                	ret
      release(&pi->lock);
    80004254:	8526                	mv	a0,s1
    80004256:	00002097          	auipc	ra,0x2
    8000425a:	21a080e7          	jalr	538(ra) # 80006470 <release>
      return -1;
    8000425e:	59fd                	li	s3,-1
    80004260:	bff9                	j	8000423e <piperead+0xca>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004262:	4981                	li	s3,0
    80004264:	b7d1                	j	80004228 <piperead+0xb4>

0000000080004266 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80004266:	1141                	addi	sp,sp,-16
    80004268:	e422                	sd	s0,8(sp)
    8000426a:	0800                	addi	s0,sp,16
    8000426c:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    8000426e:	8905                	andi	a0,a0,1
    80004270:	c111                	beqz	a0,80004274 <flags2perm+0xe>
      perm = PTE_X;
    80004272:	4521                	li	a0,8
    if(flags & 0x2)
    80004274:	8b89                	andi	a5,a5,2
    80004276:	c399                	beqz	a5,8000427c <flags2perm+0x16>
      perm |= PTE_W;
    80004278:	00456513          	ori	a0,a0,4
    return perm;
}
    8000427c:	6422                	ld	s0,8(sp)
    8000427e:	0141                	addi	sp,sp,16
    80004280:	8082                	ret

0000000080004282 <exec>:

int
exec(char *path, char **argv)
{
    80004282:	df010113          	addi	sp,sp,-528
    80004286:	20113423          	sd	ra,520(sp)
    8000428a:	20813023          	sd	s0,512(sp)
    8000428e:	ffa6                	sd	s1,504(sp)
    80004290:	fbca                	sd	s2,496(sp)
    80004292:	f7ce                	sd	s3,488(sp)
    80004294:	f3d2                	sd	s4,480(sp)
    80004296:	efd6                	sd	s5,472(sp)
    80004298:	ebda                	sd	s6,464(sp)
    8000429a:	e7de                	sd	s7,456(sp)
    8000429c:	e3e2                	sd	s8,448(sp)
    8000429e:	ff66                	sd	s9,440(sp)
    800042a0:	fb6a                	sd	s10,432(sp)
    800042a2:	f76e                	sd	s11,424(sp)
    800042a4:	0c00                	addi	s0,sp,528
    800042a6:	84aa                	mv	s1,a0
    800042a8:	dea43c23          	sd	a0,-520(s0)
    800042ac:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800042b0:	ffffd097          	auipc	ra,0xffffd
    800042b4:	c90080e7          	jalr	-880(ra) # 80000f40 <myproc>
    800042b8:	892a                	mv	s2,a0

  begin_op();
    800042ba:	fffff097          	auipc	ra,0xfffff
    800042be:	474080e7          	jalr	1140(ra) # 8000372e <begin_op>

  if((ip = namei(path)) == 0){
    800042c2:	8526                	mv	a0,s1
    800042c4:	fffff097          	auipc	ra,0xfffff
    800042c8:	24e080e7          	jalr	590(ra) # 80003512 <namei>
    800042cc:	c92d                	beqz	a0,8000433e <exec+0xbc>
    800042ce:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800042d0:	fffff097          	auipc	ra,0xfffff
    800042d4:	a9c080e7          	jalr	-1380(ra) # 80002d6c <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800042d8:	04000713          	li	a4,64
    800042dc:	4681                	li	a3,0
    800042de:	e5040613          	addi	a2,s0,-432
    800042e2:	4581                	li	a1,0
    800042e4:	8526                	mv	a0,s1
    800042e6:	fffff097          	auipc	ra,0xfffff
    800042ea:	d3a080e7          	jalr	-710(ra) # 80003020 <readi>
    800042ee:	04000793          	li	a5,64
    800042f2:	00f51a63          	bne	a0,a5,80004306 <exec+0x84>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    800042f6:	e5042703          	lw	a4,-432(s0)
    800042fa:	464c47b7          	lui	a5,0x464c4
    800042fe:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004302:	04f70463          	beq	a4,a5,8000434a <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004306:	8526                	mv	a0,s1
    80004308:	fffff097          	auipc	ra,0xfffff
    8000430c:	cc6080e7          	jalr	-826(ra) # 80002fce <iunlockput>
    end_op();
    80004310:	fffff097          	auipc	ra,0xfffff
    80004314:	49e080e7          	jalr	1182(ra) # 800037ae <end_op>
  }
  return -1;
    80004318:	557d                	li	a0,-1
}
    8000431a:	20813083          	ld	ra,520(sp)
    8000431e:	20013403          	ld	s0,512(sp)
    80004322:	74fe                	ld	s1,504(sp)
    80004324:	795e                	ld	s2,496(sp)
    80004326:	79be                	ld	s3,488(sp)
    80004328:	7a1e                	ld	s4,480(sp)
    8000432a:	6afe                	ld	s5,472(sp)
    8000432c:	6b5e                	ld	s6,464(sp)
    8000432e:	6bbe                	ld	s7,456(sp)
    80004330:	6c1e                	ld	s8,448(sp)
    80004332:	7cfa                	ld	s9,440(sp)
    80004334:	7d5a                	ld	s10,432(sp)
    80004336:	7dba                	ld	s11,424(sp)
    80004338:	21010113          	addi	sp,sp,528
    8000433c:	8082                	ret
    end_op();
    8000433e:	fffff097          	auipc	ra,0xfffff
    80004342:	470080e7          	jalr	1136(ra) # 800037ae <end_op>
    return -1;
    80004346:	557d                	li	a0,-1
    80004348:	bfc9                	j	8000431a <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    8000434a:	854a                	mv	a0,s2
    8000434c:	ffffd097          	auipc	ra,0xffffd
    80004350:	cb8080e7          	jalr	-840(ra) # 80001004 <proc_pagetable>
    80004354:	8baa                	mv	s7,a0
    80004356:	d945                	beqz	a0,80004306 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004358:	e7042983          	lw	s3,-400(s0)
    8000435c:	e8845783          	lhu	a5,-376(s0)
    80004360:	c7ad                	beqz	a5,800043ca <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004362:	4a01                	li	s4,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004364:	4b01                	li	s6,0
    if(ph.vaddr % PGSIZE != 0)
    80004366:	6c85                	lui	s9,0x1
    80004368:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    8000436c:	def43823          	sd	a5,-528(s0)
    80004370:	ac0d                	j	800045a2 <exec+0x320>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004372:	00004517          	auipc	a0,0x4
    80004376:	38650513          	addi	a0,a0,902 # 800086f8 <syscalls+0x2c8>
    8000437a:	00002097          	auipc	ra,0x2
    8000437e:	af8080e7          	jalr	-1288(ra) # 80005e72 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004382:	8756                	mv	a4,s5
    80004384:	012d86bb          	addw	a3,s11,s2
    80004388:	4581                	li	a1,0
    8000438a:	8526                	mv	a0,s1
    8000438c:	fffff097          	auipc	ra,0xfffff
    80004390:	c94080e7          	jalr	-876(ra) # 80003020 <readi>
    80004394:	2501                	sext.w	a0,a0
    80004396:	1aaa9a63          	bne	s5,a0,8000454a <exec+0x2c8>
  for(i = 0; i < sz; i += PGSIZE){
    8000439a:	6785                	lui	a5,0x1
    8000439c:	0127893b          	addw	s2,a5,s2
    800043a0:	77fd                	lui	a5,0xfffff
    800043a2:	01478a3b          	addw	s4,a5,s4
    800043a6:	1f897563          	bgeu	s2,s8,80004590 <exec+0x30e>
    pa = walkaddr(pagetable, va + i);
    800043aa:	02091593          	slli	a1,s2,0x20
    800043ae:	9181                	srli	a1,a1,0x20
    800043b0:	95ea                	add	a1,a1,s10
    800043b2:	855e                	mv	a0,s7
    800043b4:	ffffc097          	auipc	ra,0xffffc
    800043b8:	156080e7          	jalr	342(ra) # 8000050a <walkaddr>
    800043bc:	862a                	mv	a2,a0
    if(pa == 0)
    800043be:	d955                	beqz	a0,80004372 <exec+0xf0>
      n = PGSIZE;
    800043c0:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    800043c2:	fd9a70e3          	bgeu	s4,s9,80004382 <exec+0x100>
      n = sz - i;
    800043c6:	8ad2                	mv	s5,s4
    800043c8:	bf6d                	j	80004382 <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800043ca:	4a01                	li	s4,0
  iunlockput(ip);
    800043cc:	8526                	mv	a0,s1
    800043ce:	fffff097          	auipc	ra,0xfffff
    800043d2:	c00080e7          	jalr	-1024(ra) # 80002fce <iunlockput>
  end_op();
    800043d6:	fffff097          	auipc	ra,0xfffff
    800043da:	3d8080e7          	jalr	984(ra) # 800037ae <end_op>
  p = myproc();
    800043de:	ffffd097          	auipc	ra,0xffffd
    800043e2:	b62080e7          	jalr	-1182(ra) # 80000f40 <myproc>
    800043e6:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800043e8:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800043ec:	6785                	lui	a5,0x1
    800043ee:	17fd                	addi	a5,a5,-1
    800043f0:	9a3e                	add	s4,s4,a5
    800043f2:	757d                	lui	a0,0xfffff
    800043f4:	00aa77b3          	and	a5,s4,a0
    800043f8:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    800043fc:	4691                	li	a3,4
    800043fe:	6609                	lui	a2,0x2
    80004400:	963e                	add	a2,a2,a5
    80004402:	85be                	mv	a1,a5
    80004404:	855e                	mv	a0,s7
    80004406:	ffffc097          	auipc	ra,0xffffc
    8000440a:	4b8080e7          	jalr	1208(ra) # 800008be <uvmalloc>
    8000440e:	8b2a                	mv	s6,a0
  ip = 0;
    80004410:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004412:	12050c63          	beqz	a0,8000454a <exec+0x2c8>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004416:	75f9                	lui	a1,0xffffe
    80004418:	95aa                	add	a1,a1,a0
    8000441a:	855e                	mv	a0,s7
    8000441c:	ffffc097          	auipc	ra,0xffffc
    80004420:	6c8080e7          	jalr	1736(ra) # 80000ae4 <uvmclear>
  stackbase = sp - PGSIZE;
    80004424:	7c7d                	lui	s8,0xfffff
    80004426:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    80004428:	e0043783          	ld	a5,-512(s0)
    8000442c:	6388                	ld	a0,0(a5)
    8000442e:	c535                	beqz	a0,8000449a <exec+0x218>
    80004430:	e9040993          	addi	s3,s0,-368
    80004434:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004438:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    8000443a:	ffffc097          	auipc	ra,0xffffc
    8000443e:	ec2080e7          	jalr	-318(ra) # 800002fc <strlen>
    80004442:	2505                	addiw	a0,a0,1
    80004444:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004448:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    8000444c:	13896663          	bltu	s2,s8,80004578 <exec+0x2f6>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004450:	e0043d83          	ld	s11,-512(s0)
    80004454:	000dba03          	ld	s4,0(s11)
    80004458:	8552                	mv	a0,s4
    8000445a:	ffffc097          	auipc	ra,0xffffc
    8000445e:	ea2080e7          	jalr	-350(ra) # 800002fc <strlen>
    80004462:	0015069b          	addiw	a3,a0,1
    80004466:	8652                	mv	a2,s4
    80004468:	85ca                	mv	a1,s2
    8000446a:	855e                	mv	a0,s7
    8000446c:	ffffc097          	auipc	ra,0xffffc
    80004470:	6aa080e7          	jalr	1706(ra) # 80000b16 <copyout>
    80004474:	10054663          	bltz	a0,80004580 <exec+0x2fe>
    ustack[argc] = sp;
    80004478:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    8000447c:	0485                	addi	s1,s1,1
    8000447e:	008d8793          	addi	a5,s11,8
    80004482:	e0f43023          	sd	a5,-512(s0)
    80004486:	008db503          	ld	a0,8(s11)
    8000448a:	c911                	beqz	a0,8000449e <exec+0x21c>
    if(argc >= MAXARG)
    8000448c:	09a1                	addi	s3,s3,8
    8000448e:	fb3c96e3          	bne	s9,s3,8000443a <exec+0x1b8>
  sz = sz1;
    80004492:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004496:	4481                	li	s1,0
    80004498:	a84d                	j	8000454a <exec+0x2c8>
  sp = sz;
    8000449a:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    8000449c:	4481                	li	s1,0
  ustack[argc] = 0;
    8000449e:	00349793          	slli	a5,s1,0x3
    800044a2:	f9040713          	addi	a4,s0,-112
    800044a6:	97ba                	add	a5,a5,a4
    800044a8:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    800044ac:	00148693          	addi	a3,s1,1
    800044b0:	068e                	slli	a3,a3,0x3
    800044b2:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800044b6:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    800044ba:	01897663          	bgeu	s2,s8,800044c6 <exec+0x244>
  sz = sz1;
    800044be:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800044c2:	4481                	li	s1,0
    800044c4:	a059                	j	8000454a <exec+0x2c8>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800044c6:	e9040613          	addi	a2,s0,-368
    800044ca:	85ca                	mv	a1,s2
    800044cc:	855e                	mv	a0,s7
    800044ce:	ffffc097          	auipc	ra,0xffffc
    800044d2:	648080e7          	jalr	1608(ra) # 80000b16 <copyout>
    800044d6:	0a054963          	bltz	a0,80004588 <exec+0x306>
  p->trapframe->a1 = sp;
    800044da:	058ab783          	ld	a5,88(s5)
    800044de:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800044e2:	df843783          	ld	a5,-520(s0)
    800044e6:	0007c703          	lbu	a4,0(a5)
    800044ea:	cf11                	beqz	a4,80004506 <exec+0x284>
    800044ec:	0785                	addi	a5,a5,1
    if(*s == '/')
    800044ee:	02f00693          	li	a3,47
    800044f2:	a039                	j	80004500 <exec+0x27e>
      last = s+1;
    800044f4:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    800044f8:	0785                	addi	a5,a5,1
    800044fa:	fff7c703          	lbu	a4,-1(a5)
    800044fe:	c701                	beqz	a4,80004506 <exec+0x284>
    if(*s == '/')
    80004500:	fed71ce3          	bne	a4,a3,800044f8 <exec+0x276>
    80004504:	bfc5                	j	800044f4 <exec+0x272>
  safestrcpy(p->name, last, sizeof(p->name));
    80004506:	4641                	li	a2,16
    80004508:	df843583          	ld	a1,-520(s0)
    8000450c:	158a8513          	addi	a0,s5,344
    80004510:	ffffc097          	auipc	ra,0xffffc
    80004514:	dba080e7          	jalr	-582(ra) # 800002ca <safestrcpy>
  oldpagetable = p->pagetable;
    80004518:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    8000451c:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    80004520:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004524:	058ab783          	ld	a5,88(s5)
    80004528:	e6843703          	ld	a4,-408(s0)
    8000452c:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000452e:	058ab783          	ld	a5,88(s5)
    80004532:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004536:	85ea                	mv	a1,s10
    80004538:	ffffd097          	auipc	ra,0xffffd
    8000453c:	bd8080e7          	jalr	-1064(ra) # 80001110 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004540:	0004851b          	sext.w	a0,s1
    80004544:	bbd9                	j	8000431a <exec+0x98>
    80004546:	e1443423          	sd	s4,-504(s0)
    proc_freepagetable(pagetable, sz);
    8000454a:	e0843583          	ld	a1,-504(s0)
    8000454e:	855e                	mv	a0,s7
    80004550:	ffffd097          	auipc	ra,0xffffd
    80004554:	bc0080e7          	jalr	-1088(ra) # 80001110 <proc_freepagetable>
  if(ip){
    80004558:	da0497e3          	bnez	s1,80004306 <exec+0x84>
  return -1;
    8000455c:	557d                	li	a0,-1
    8000455e:	bb75                	j	8000431a <exec+0x98>
    80004560:	e1443423          	sd	s4,-504(s0)
    80004564:	b7dd                	j	8000454a <exec+0x2c8>
    80004566:	e1443423          	sd	s4,-504(s0)
    8000456a:	b7c5                	j	8000454a <exec+0x2c8>
    8000456c:	e1443423          	sd	s4,-504(s0)
    80004570:	bfe9                	j	8000454a <exec+0x2c8>
    80004572:	e1443423          	sd	s4,-504(s0)
    80004576:	bfd1                	j	8000454a <exec+0x2c8>
  sz = sz1;
    80004578:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000457c:	4481                	li	s1,0
    8000457e:	b7f1                	j	8000454a <exec+0x2c8>
  sz = sz1;
    80004580:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004584:	4481                	li	s1,0
    80004586:	b7d1                	j	8000454a <exec+0x2c8>
  sz = sz1;
    80004588:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000458c:	4481                	li	s1,0
    8000458e:	bf75                	j	8000454a <exec+0x2c8>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004590:	e0843a03          	ld	s4,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004594:	2b05                	addiw	s6,s6,1
    80004596:	0389899b          	addiw	s3,s3,56
    8000459a:	e8845783          	lhu	a5,-376(s0)
    8000459e:	e2fb57e3          	bge	s6,a5,800043cc <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800045a2:	2981                	sext.w	s3,s3
    800045a4:	03800713          	li	a4,56
    800045a8:	86ce                	mv	a3,s3
    800045aa:	e1840613          	addi	a2,s0,-488
    800045ae:	4581                	li	a1,0
    800045b0:	8526                	mv	a0,s1
    800045b2:	fffff097          	auipc	ra,0xfffff
    800045b6:	a6e080e7          	jalr	-1426(ra) # 80003020 <readi>
    800045ba:	03800793          	li	a5,56
    800045be:	f8f514e3          	bne	a0,a5,80004546 <exec+0x2c4>
    if(ph.type != ELF_PROG_LOAD)
    800045c2:	e1842783          	lw	a5,-488(s0)
    800045c6:	4705                	li	a4,1
    800045c8:	fce796e3          	bne	a5,a4,80004594 <exec+0x312>
    if(ph.memsz < ph.filesz)
    800045cc:	e4043903          	ld	s2,-448(s0)
    800045d0:	e3843783          	ld	a5,-456(s0)
    800045d4:	f8f966e3          	bltu	s2,a5,80004560 <exec+0x2de>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800045d8:	e2843783          	ld	a5,-472(s0)
    800045dc:	993e                	add	s2,s2,a5
    800045de:	f8f964e3          	bltu	s2,a5,80004566 <exec+0x2e4>
    if(ph.vaddr % PGSIZE != 0)
    800045e2:	df043703          	ld	a4,-528(s0)
    800045e6:	8ff9                	and	a5,a5,a4
    800045e8:	f3d1                	bnez	a5,8000456c <exec+0x2ea>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800045ea:	e1c42503          	lw	a0,-484(s0)
    800045ee:	00000097          	auipc	ra,0x0
    800045f2:	c78080e7          	jalr	-904(ra) # 80004266 <flags2perm>
    800045f6:	86aa                	mv	a3,a0
    800045f8:	864a                	mv	a2,s2
    800045fa:	85d2                	mv	a1,s4
    800045fc:	855e                	mv	a0,s7
    800045fe:	ffffc097          	auipc	ra,0xffffc
    80004602:	2c0080e7          	jalr	704(ra) # 800008be <uvmalloc>
    80004606:	e0a43423          	sd	a0,-504(s0)
    8000460a:	d525                	beqz	a0,80004572 <exec+0x2f0>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000460c:	e2843d03          	ld	s10,-472(s0)
    80004610:	e2042d83          	lw	s11,-480(s0)
    80004614:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004618:	f60c0ce3          	beqz	s8,80004590 <exec+0x30e>
    8000461c:	8a62                	mv	s4,s8
    8000461e:	4901                	li	s2,0
    80004620:	b369                	j	800043aa <exec+0x128>

0000000080004622 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004622:	7179                	addi	sp,sp,-48
    80004624:	f406                	sd	ra,40(sp)
    80004626:	f022                	sd	s0,32(sp)
    80004628:	ec26                	sd	s1,24(sp)
    8000462a:	e84a                	sd	s2,16(sp)
    8000462c:	1800                	addi	s0,sp,48
    8000462e:	892e                	mv	s2,a1
    80004630:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004632:	fdc40593          	addi	a1,s0,-36
    80004636:	ffffe097          	auipc	ra,0xffffe
    8000463a:	ae2080e7          	jalr	-1310(ra) # 80002118 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000463e:	fdc42703          	lw	a4,-36(s0)
    80004642:	47bd                	li	a5,15
    80004644:	02e7eb63          	bltu	a5,a4,8000467a <argfd+0x58>
    80004648:	ffffd097          	auipc	ra,0xffffd
    8000464c:	8f8080e7          	jalr	-1800(ra) # 80000f40 <myproc>
    80004650:	fdc42703          	lw	a4,-36(s0)
    80004654:	01a70793          	addi	a5,a4,26
    80004658:	078e                	slli	a5,a5,0x3
    8000465a:	953e                	add	a0,a0,a5
    8000465c:	611c                	ld	a5,0(a0)
    8000465e:	c385                	beqz	a5,8000467e <argfd+0x5c>
    return -1;
  if(pfd)
    80004660:	00090463          	beqz	s2,80004668 <argfd+0x46>
    *pfd = fd;
    80004664:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004668:	4501                	li	a0,0
  if(pf)
    8000466a:	c091                	beqz	s1,8000466e <argfd+0x4c>
    *pf = f;
    8000466c:	e09c                	sd	a5,0(s1)
}
    8000466e:	70a2                	ld	ra,40(sp)
    80004670:	7402                	ld	s0,32(sp)
    80004672:	64e2                	ld	s1,24(sp)
    80004674:	6942                	ld	s2,16(sp)
    80004676:	6145                	addi	sp,sp,48
    80004678:	8082                	ret
    return -1;
    8000467a:	557d                	li	a0,-1
    8000467c:	bfcd                	j	8000466e <argfd+0x4c>
    8000467e:	557d                	li	a0,-1
    80004680:	b7fd                	j	8000466e <argfd+0x4c>

0000000080004682 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004682:	1101                	addi	sp,sp,-32
    80004684:	ec06                	sd	ra,24(sp)
    80004686:	e822                	sd	s0,16(sp)
    80004688:	e426                	sd	s1,8(sp)
    8000468a:	1000                	addi	s0,sp,32
    8000468c:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000468e:	ffffd097          	auipc	ra,0xffffd
    80004692:	8b2080e7          	jalr	-1870(ra) # 80000f40 <myproc>
    80004696:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004698:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7ffdd0d0>
    8000469c:	4501                	li	a0,0
    8000469e:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800046a0:	6398                	ld	a4,0(a5)
    800046a2:	cb19                	beqz	a4,800046b8 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800046a4:	2505                	addiw	a0,a0,1
    800046a6:	07a1                	addi	a5,a5,8
    800046a8:	fed51ce3          	bne	a0,a3,800046a0 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800046ac:	557d                	li	a0,-1
}
    800046ae:	60e2                	ld	ra,24(sp)
    800046b0:	6442                	ld	s0,16(sp)
    800046b2:	64a2                	ld	s1,8(sp)
    800046b4:	6105                	addi	sp,sp,32
    800046b6:	8082                	ret
      p->ofile[fd] = f;
    800046b8:	01a50793          	addi	a5,a0,26
    800046bc:	078e                	slli	a5,a5,0x3
    800046be:	963e                	add	a2,a2,a5
    800046c0:	e204                	sd	s1,0(a2)
      return fd;
    800046c2:	b7f5                	j	800046ae <fdalloc+0x2c>

00000000800046c4 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800046c4:	715d                	addi	sp,sp,-80
    800046c6:	e486                	sd	ra,72(sp)
    800046c8:	e0a2                	sd	s0,64(sp)
    800046ca:	fc26                	sd	s1,56(sp)
    800046cc:	f84a                	sd	s2,48(sp)
    800046ce:	f44e                	sd	s3,40(sp)
    800046d0:	f052                	sd	s4,32(sp)
    800046d2:	ec56                	sd	s5,24(sp)
    800046d4:	e85a                	sd	s6,16(sp)
    800046d6:	0880                	addi	s0,sp,80
    800046d8:	8b2e                	mv	s6,a1
    800046da:	89b2                	mv	s3,a2
    800046dc:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800046de:	fb040593          	addi	a1,s0,-80
    800046e2:	fffff097          	auipc	ra,0xfffff
    800046e6:	e4e080e7          	jalr	-434(ra) # 80003530 <nameiparent>
    800046ea:	84aa                	mv	s1,a0
    800046ec:	16050063          	beqz	a0,8000484c <create+0x188>
    return 0;

  ilock(dp);
    800046f0:	ffffe097          	auipc	ra,0xffffe
    800046f4:	67c080e7          	jalr	1660(ra) # 80002d6c <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800046f8:	4601                	li	a2,0
    800046fa:	fb040593          	addi	a1,s0,-80
    800046fe:	8526                	mv	a0,s1
    80004700:	fffff097          	auipc	ra,0xfffff
    80004704:	b50080e7          	jalr	-1200(ra) # 80003250 <dirlookup>
    80004708:	8aaa                	mv	s5,a0
    8000470a:	c931                	beqz	a0,8000475e <create+0x9a>
    iunlockput(dp);
    8000470c:	8526                	mv	a0,s1
    8000470e:	fffff097          	auipc	ra,0xfffff
    80004712:	8c0080e7          	jalr	-1856(ra) # 80002fce <iunlockput>
    ilock(ip);
    80004716:	8556                	mv	a0,s5
    80004718:	ffffe097          	auipc	ra,0xffffe
    8000471c:	654080e7          	jalr	1620(ra) # 80002d6c <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004720:	000b059b          	sext.w	a1,s6
    80004724:	4789                	li	a5,2
    80004726:	02f59563          	bne	a1,a5,80004750 <create+0x8c>
    8000472a:	044ad783          	lhu	a5,68(s5)
    8000472e:	37f9                	addiw	a5,a5,-2
    80004730:	17c2                	slli	a5,a5,0x30
    80004732:	93c1                	srli	a5,a5,0x30
    80004734:	4705                	li	a4,1
    80004736:	00f76d63          	bltu	a4,a5,80004750 <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    8000473a:	8556                	mv	a0,s5
    8000473c:	60a6                	ld	ra,72(sp)
    8000473e:	6406                	ld	s0,64(sp)
    80004740:	74e2                	ld	s1,56(sp)
    80004742:	7942                	ld	s2,48(sp)
    80004744:	79a2                	ld	s3,40(sp)
    80004746:	7a02                	ld	s4,32(sp)
    80004748:	6ae2                	ld	s5,24(sp)
    8000474a:	6b42                	ld	s6,16(sp)
    8000474c:	6161                	addi	sp,sp,80
    8000474e:	8082                	ret
    iunlockput(ip);
    80004750:	8556                	mv	a0,s5
    80004752:	fffff097          	auipc	ra,0xfffff
    80004756:	87c080e7          	jalr	-1924(ra) # 80002fce <iunlockput>
    return 0;
    8000475a:	4a81                	li	s5,0
    8000475c:	bff9                	j	8000473a <create+0x76>
  if((ip = ialloc(dp->dev, type)) == 0){
    8000475e:	85da                	mv	a1,s6
    80004760:	4088                	lw	a0,0(s1)
    80004762:	ffffe097          	auipc	ra,0xffffe
    80004766:	46e080e7          	jalr	1134(ra) # 80002bd0 <ialloc>
    8000476a:	8a2a                	mv	s4,a0
    8000476c:	c921                	beqz	a0,800047bc <create+0xf8>
  ilock(ip);
    8000476e:	ffffe097          	auipc	ra,0xffffe
    80004772:	5fe080e7          	jalr	1534(ra) # 80002d6c <ilock>
  ip->major = major;
    80004776:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    8000477a:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    8000477e:	4785                	li	a5,1
    80004780:	04fa1523          	sh	a5,74(s4)
  iupdate(ip);
    80004784:	8552                	mv	a0,s4
    80004786:	ffffe097          	auipc	ra,0xffffe
    8000478a:	51c080e7          	jalr	1308(ra) # 80002ca2 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000478e:	000b059b          	sext.w	a1,s6
    80004792:	4785                	li	a5,1
    80004794:	02f58b63          	beq	a1,a5,800047ca <create+0x106>
  if(dirlink(dp, name, ip->inum) < 0)
    80004798:	004a2603          	lw	a2,4(s4)
    8000479c:	fb040593          	addi	a1,s0,-80
    800047a0:	8526                	mv	a0,s1
    800047a2:	fffff097          	auipc	ra,0xfffff
    800047a6:	cbe080e7          	jalr	-834(ra) # 80003460 <dirlink>
    800047aa:	06054f63          	bltz	a0,80004828 <create+0x164>
  iunlockput(dp);
    800047ae:	8526                	mv	a0,s1
    800047b0:	fffff097          	auipc	ra,0xfffff
    800047b4:	81e080e7          	jalr	-2018(ra) # 80002fce <iunlockput>
  return ip;
    800047b8:	8ad2                	mv	s5,s4
    800047ba:	b741                	j	8000473a <create+0x76>
    iunlockput(dp);
    800047bc:	8526                	mv	a0,s1
    800047be:	fffff097          	auipc	ra,0xfffff
    800047c2:	810080e7          	jalr	-2032(ra) # 80002fce <iunlockput>
    return 0;
    800047c6:	8ad2                	mv	s5,s4
    800047c8:	bf8d                	j	8000473a <create+0x76>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800047ca:	004a2603          	lw	a2,4(s4)
    800047ce:	00004597          	auipc	a1,0x4
    800047d2:	f4a58593          	addi	a1,a1,-182 # 80008718 <syscalls+0x2e8>
    800047d6:	8552                	mv	a0,s4
    800047d8:	fffff097          	auipc	ra,0xfffff
    800047dc:	c88080e7          	jalr	-888(ra) # 80003460 <dirlink>
    800047e0:	04054463          	bltz	a0,80004828 <create+0x164>
    800047e4:	40d0                	lw	a2,4(s1)
    800047e6:	00004597          	auipc	a1,0x4
    800047ea:	f3a58593          	addi	a1,a1,-198 # 80008720 <syscalls+0x2f0>
    800047ee:	8552                	mv	a0,s4
    800047f0:	fffff097          	auipc	ra,0xfffff
    800047f4:	c70080e7          	jalr	-912(ra) # 80003460 <dirlink>
    800047f8:	02054863          	bltz	a0,80004828 <create+0x164>
  if(dirlink(dp, name, ip->inum) < 0)
    800047fc:	004a2603          	lw	a2,4(s4)
    80004800:	fb040593          	addi	a1,s0,-80
    80004804:	8526                	mv	a0,s1
    80004806:	fffff097          	auipc	ra,0xfffff
    8000480a:	c5a080e7          	jalr	-934(ra) # 80003460 <dirlink>
    8000480e:	00054d63          	bltz	a0,80004828 <create+0x164>
    dp->nlink++;  // for ".."
    80004812:	04a4d783          	lhu	a5,74(s1)
    80004816:	2785                	addiw	a5,a5,1
    80004818:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000481c:	8526                	mv	a0,s1
    8000481e:	ffffe097          	auipc	ra,0xffffe
    80004822:	484080e7          	jalr	1156(ra) # 80002ca2 <iupdate>
    80004826:	b761                	j	800047ae <create+0xea>
  ip->nlink = 0;
    80004828:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    8000482c:	8552                	mv	a0,s4
    8000482e:	ffffe097          	auipc	ra,0xffffe
    80004832:	474080e7          	jalr	1140(ra) # 80002ca2 <iupdate>
  iunlockput(ip);
    80004836:	8552                	mv	a0,s4
    80004838:	ffffe097          	auipc	ra,0xffffe
    8000483c:	796080e7          	jalr	1942(ra) # 80002fce <iunlockput>
  iunlockput(dp);
    80004840:	8526                	mv	a0,s1
    80004842:	ffffe097          	auipc	ra,0xffffe
    80004846:	78c080e7          	jalr	1932(ra) # 80002fce <iunlockput>
  return 0;
    8000484a:	bdc5                	j	8000473a <create+0x76>
    return 0;
    8000484c:	8aaa                	mv	s5,a0
    8000484e:	b5f5                	j	8000473a <create+0x76>

0000000080004850 <sys_dup>:
{
    80004850:	7179                	addi	sp,sp,-48
    80004852:	f406                	sd	ra,40(sp)
    80004854:	f022                	sd	s0,32(sp)
    80004856:	ec26                	sd	s1,24(sp)
    80004858:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000485a:	fd840613          	addi	a2,s0,-40
    8000485e:	4581                	li	a1,0
    80004860:	4501                	li	a0,0
    80004862:	00000097          	auipc	ra,0x0
    80004866:	dc0080e7          	jalr	-576(ra) # 80004622 <argfd>
    return -1;
    8000486a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000486c:	02054363          	bltz	a0,80004892 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    80004870:	fd843503          	ld	a0,-40(s0)
    80004874:	00000097          	auipc	ra,0x0
    80004878:	e0e080e7          	jalr	-498(ra) # 80004682 <fdalloc>
    8000487c:	84aa                	mv	s1,a0
    return -1;
    8000487e:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004880:	00054963          	bltz	a0,80004892 <sys_dup+0x42>
  filedup(f);
    80004884:	fd843503          	ld	a0,-40(s0)
    80004888:	fffff097          	auipc	ra,0xfffff
    8000488c:	320080e7          	jalr	800(ra) # 80003ba8 <filedup>
  return fd;
    80004890:	87a6                	mv	a5,s1
}
    80004892:	853e                	mv	a0,a5
    80004894:	70a2                	ld	ra,40(sp)
    80004896:	7402                	ld	s0,32(sp)
    80004898:	64e2                	ld	s1,24(sp)
    8000489a:	6145                	addi	sp,sp,48
    8000489c:	8082                	ret

000000008000489e <sys_read>:
{
    8000489e:	7179                	addi	sp,sp,-48
    800048a0:	f406                	sd	ra,40(sp)
    800048a2:	f022                	sd	s0,32(sp)
    800048a4:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800048a6:	fd840593          	addi	a1,s0,-40
    800048aa:	4505                	li	a0,1
    800048ac:	ffffe097          	auipc	ra,0xffffe
    800048b0:	88c080e7          	jalr	-1908(ra) # 80002138 <argaddr>
  argint(2, &n);
    800048b4:	fe440593          	addi	a1,s0,-28
    800048b8:	4509                	li	a0,2
    800048ba:	ffffe097          	auipc	ra,0xffffe
    800048be:	85e080e7          	jalr	-1954(ra) # 80002118 <argint>
  if(argfd(0, 0, &f) < 0)
    800048c2:	fe840613          	addi	a2,s0,-24
    800048c6:	4581                	li	a1,0
    800048c8:	4501                	li	a0,0
    800048ca:	00000097          	auipc	ra,0x0
    800048ce:	d58080e7          	jalr	-680(ra) # 80004622 <argfd>
    800048d2:	87aa                	mv	a5,a0
    return -1;
    800048d4:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800048d6:	0007cc63          	bltz	a5,800048ee <sys_read+0x50>
  return fileread(f, p, n);
    800048da:	fe442603          	lw	a2,-28(s0)
    800048de:	fd843583          	ld	a1,-40(s0)
    800048e2:	fe843503          	ld	a0,-24(s0)
    800048e6:	fffff097          	auipc	ra,0xfffff
    800048ea:	44e080e7          	jalr	1102(ra) # 80003d34 <fileread>
}
    800048ee:	70a2                	ld	ra,40(sp)
    800048f0:	7402                	ld	s0,32(sp)
    800048f2:	6145                	addi	sp,sp,48
    800048f4:	8082                	ret

00000000800048f6 <sys_write>:
{
    800048f6:	7179                	addi	sp,sp,-48
    800048f8:	f406                	sd	ra,40(sp)
    800048fa:	f022                	sd	s0,32(sp)
    800048fc:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800048fe:	fd840593          	addi	a1,s0,-40
    80004902:	4505                	li	a0,1
    80004904:	ffffe097          	auipc	ra,0xffffe
    80004908:	834080e7          	jalr	-1996(ra) # 80002138 <argaddr>
  argint(2, &n);
    8000490c:	fe440593          	addi	a1,s0,-28
    80004910:	4509                	li	a0,2
    80004912:	ffffe097          	auipc	ra,0xffffe
    80004916:	806080e7          	jalr	-2042(ra) # 80002118 <argint>
  if(argfd(0, 0, &f) < 0)
    8000491a:	fe840613          	addi	a2,s0,-24
    8000491e:	4581                	li	a1,0
    80004920:	4501                	li	a0,0
    80004922:	00000097          	auipc	ra,0x0
    80004926:	d00080e7          	jalr	-768(ra) # 80004622 <argfd>
    8000492a:	87aa                	mv	a5,a0
    return -1;
    8000492c:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000492e:	0007cc63          	bltz	a5,80004946 <sys_write+0x50>
  return filewrite(f, p, n);
    80004932:	fe442603          	lw	a2,-28(s0)
    80004936:	fd843583          	ld	a1,-40(s0)
    8000493a:	fe843503          	ld	a0,-24(s0)
    8000493e:	fffff097          	auipc	ra,0xfffff
    80004942:	4b8080e7          	jalr	1208(ra) # 80003df6 <filewrite>
}
    80004946:	70a2                	ld	ra,40(sp)
    80004948:	7402                	ld	s0,32(sp)
    8000494a:	6145                	addi	sp,sp,48
    8000494c:	8082                	ret

000000008000494e <sys_close>:
{
    8000494e:	1101                	addi	sp,sp,-32
    80004950:	ec06                	sd	ra,24(sp)
    80004952:	e822                	sd	s0,16(sp)
    80004954:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004956:	fe040613          	addi	a2,s0,-32
    8000495a:	fec40593          	addi	a1,s0,-20
    8000495e:	4501                	li	a0,0
    80004960:	00000097          	auipc	ra,0x0
    80004964:	cc2080e7          	jalr	-830(ra) # 80004622 <argfd>
    return -1;
    80004968:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000496a:	02054463          	bltz	a0,80004992 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    8000496e:	ffffc097          	auipc	ra,0xffffc
    80004972:	5d2080e7          	jalr	1490(ra) # 80000f40 <myproc>
    80004976:	fec42783          	lw	a5,-20(s0)
    8000497a:	07e9                	addi	a5,a5,26
    8000497c:	078e                	slli	a5,a5,0x3
    8000497e:	97aa                	add	a5,a5,a0
    80004980:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    80004984:	fe043503          	ld	a0,-32(s0)
    80004988:	fffff097          	auipc	ra,0xfffff
    8000498c:	272080e7          	jalr	626(ra) # 80003bfa <fileclose>
  return 0;
    80004990:	4781                	li	a5,0
}
    80004992:	853e                	mv	a0,a5
    80004994:	60e2                	ld	ra,24(sp)
    80004996:	6442                	ld	s0,16(sp)
    80004998:	6105                	addi	sp,sp,32
    8000499a:	8082                	ret

000000008000499c <sys_fstat>:
{
    8000499c:	1101                	addi	sp,sp,-32
    8000499e:	ec06                	sd	ra,24(sp)
    800049a0:	e822                	sd	s0,16(sp)
    800049a2:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    800049a4:	fe040593          	addi	a1,s0,-32
    800049a8:	4505                	li	a0,1
    800049aa:	ffffd097          	auipc	ra,0xffffd
    800049ae:	78e080e7          	jalr	1934(ra) # 80002138 <argaddr>
  if(argfd(0, 0, &f) < 0)
    800049b2:	fe840613          	addi	a2,s0,-24
    800049b6:	4581                	li	a1,0
    800049b8:	4501                	li	a0,0
    800049ba:	00000097          	auipc	ra,0x0
    800049be:	c68080e7          	jalr	-920(ra) # 80004622 <argfd>
    800049c2:	87aa                	mv	a5,a0
    return -1;
    800049c4:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800049c6:	0007ca63          	bltz	a5,800049da <sys_fstat+0x3e>
  return filestat(f, st);
    800049ca:	fe043583          	ld	a1,-32(s0)
    800049ce:	fe843503          	ld	a0,-24(s0)
    800049d2:	fffff097          	auipc	ra,0xfffff
    800049d6:	2f0080e7          	jalr	752(ra) # 80003cc2 <filestat>
}
    800049da:	60e2                	ld	ra,24(sp)
    800049dc:	6442                	ld	s0,16(sp)
    800049de:	6105                	addi	sp,sp,32
    800049e0:	8082                	ret

00000000800049e2 <sys_link>:
{
    800049e2:	7169                	addi	sp,sp,-304
    800049e4:	f606                	sd	ra,296(sp)
    800049e6:	f222                	sd	s0,288(sp)
    800049e8:	ee26                	sd	s1,280(sp)
    800049ea:	ea4a                	sd	s2,272(sp)
    800049ec:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800049ee:	08000613          	li	a2,128
    800049f2:	ed040593          	addi	a1,s0,-304
    800049f6:	4501                	li	a0,0
    800049f8:	ffffd097          	auipc	ra,0xffffd
    800049fc:	760080e7          	jalr	1888(ra) # 80002158 <argstr>
    return -1;
    80004a00:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a02:	10054e63          	bltz	a0,80004b1e <sys_link+0x13c>
    80004a06:	08000613          	li	a2,128
    80004a0a:	f5040593          	addi	a1,s0,-176
    80004a0e:	4505                	li	a0,1
    80004a10:	ffffd097          	auipc	ra,0xffffd
    80004a14:	748080e7          	jalr	1864(ra) # 80002158 <argstr>
    return -1;
    80004a18:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a1a:	10054263          	bltz	a0,80004b1e <sys_link+0x13c>
  begin_op();
    80004a1e:	fffff097          	auipc	ra,0xfffff
    80004a22:	d10080e7          	jalr	-752(ra) # 8000372e <begin_op>
  if((ip = namei(old)) == 0){
    80004a26:	ed040513          	addi	a0,s0,-304
    80004a2a:	fffff097          	auipc	ra,0xfffff
    80004a2e:	ae8080e7          	jalr	-1304(ra) # 80003512 <namei>
    80004a32:	84aa                	mv	s1,a0
    80004a34:	c551                	beqz	a0,80004ac0 <sys_link+0xde>
  ilock(ip);
    80004a36:	ffffe097          	auipc	ra,0xffffe
    80004a3a:	336080e7          	jalr	822(ra) # 80002d6c <ilock>
  if(ip->type == T_DIR){
    80004a3e:	04449703          	lh	a4,68(s1)
    80004a42:	4785                	li	a5,1
    80004a44:	08f70463          	beq	a4,a5,80004acc <sys_link+0xea>
  ip->nlink++;
    80004a48:	04a4d783          	lhu	a5,74(s1)
    80004a4c:	2785                	addiw	a5,a5,1
    80004a4e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a52:	8526                	mv	a0,s1
    80004a54:	ffffe097          	auipc	ra,0xffffe
    80004a58:	24e080e7          	jalr	590(ra) # 80002ca2 <iupdate>
  iunlock(ip);
    80004a5c:	8526                	mv	a0,s1
    80004a5e:	ffffe097          	auipc	ra,0xffffe
    80004a62:	3d0080e7          	jalr	976(ra) # 80002e2e <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004a66:	fd040593          	addi	a1,s0,-48
    80004a6a:	f5040513          	addi	a0,s0,-176
    80004a6e:	fffff097          	auipc	ra,0xfffff
    80004a72:	ac2080e7          	jalr	-1342(ra) # 80003530 <nameiparent>
    80004a76:	892a                	mv	s2,a0
    80004a78:	c935                	beqz	a0,80004aec <sys_link+0x10a>
  ilock(dp);
    80004a7a:	ffffe097          	auipc	ra,0xffffe
    80004a7e:	2f2080e7          	jalr	754(ra) # 80002d6c <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004a82:	00092703          	lw	a4,0(s2)
    80004a86:	409c                	lw	a5,0(s1)
    80004a88:	04f71d63          	bne	a4,a5,80004ae2 <sys_link+0x100>
    80004a8c:	40d0                	lw	a2,4(s1)
    80004a8e:	fd040593          	addi	a1,s0,-48
    80004a92:	854a                	mv	a0,s2
    80004a94:	fffff097          	auipc	ra,0xfffff
    80004a98:	9cc080e7          	jalr	-1588(ra) # 80003460 <dirlink>
    80004a9c:	04054363          	bltz	a0,80004ae2 <sys_link+0x100>
  iunlockput(dp);
    80004aa0:	854a                	mv	a0,s2
    80004aa2:	ffffe097          	auipc	ra,0xffffe
    80004aa6:	52c080e7          	jalr	1324(ra) # 80002fce <iunlockput>
  iput(ip);
    80004aaa:	8526                	mv	a0,s1
    80004aac:	ffffe097          	auipc	ra,0xffffe
    80004ab0:	47a080e7          	jalr	1146(ra) # 80002f26 <iput>
  end_op();
    80004ab4:	fffff097          	auipc	ra,0xfffff
    80004ab8:	cfa080e7          	jalr	-774(ra) # 800037ae <end_op>
  return 0;
    80004abc:	4781                	li	a5,0
    80004abe:	a085                	j	80004b1e <sys_link+0x13c>
    end_op();
    80004ac0:	fffff097          	auipc	ra,0xfffff
    80004ac4:	cee080e7          	jalr	-786(ra) # 800037ae <end_op>
    return -1;
    80004ac8:	57fd                	li	a5,-1
    80004aca:	a891                	j	80004b1e <sys_link+0x13c>
    iunlockput(ip);
    80004acc:	8526                	mv	a0,s1
    80004ace:	ffffe097          	auipc	ra,0xffffe
    80004ad2:	500080e7          	jalr	1280(ra) # 80002fce <iunlockput>
    end_op();
    80004ad6:	fffff097          	auipc	ra,0xfffff
    80004ada:	cd8080e7          	jalr	-808(ra) # 800037ae <end_op>
    return -1;
    80004ade:	57fd                	li	a5,-1
    80004ae0:	a83d                	j	80004b1e <sys_link+0x13c>
    iunlockput(dp);
    80004ae2:	854a                	mv	a0,s2
    80004ae4:	ffffe097          	auipc	ra,0xffffe
    80004ae8:	4ea080e7          	jalr	1258(ra) # 80002fce <iunlockput>
  ilock(ip);
    80004aec:	8526                	mv	a0,s1
    80004aee:	ffffe097          	auipc	ra,0xffffe
    80004af2:	27e080e7          	jalr	638(ra) # 80002d6c <ilock>
  ip->nlink--;
    80004af6:	04a4d783          	lhu	a5,74(s1)
    80004afa:	37fd                	addiw	a5,a5,-1
    80004afc:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004b00:	8526                	mv	a0,s1
    80004b02:	ffffe097          	auipc	ra,0xffffe
    80004b06:	1a0080e7          	jalr	416(ra) # 80002ca2 <iupdate>
  iunlockput(ip);
    80004b0a:	8526                	mv	a0,s1
    80004b0c:	ffffe097          	auipc	ra,0xffffe
    80004b10:	4c2080e7          	jalr	1218(ra) # 80002fce <iunlockput>
  end_op();
    80004b14:	fffff097          	auipc	ra,0xfffff
    80004b18:	c9a080e7          	jalr	-870(ra) # 800037ae <end_op>
  return -1;
    80004b1c:	57fd                	li	a5,-1
}
    80004b1e:	853e                	mv	a0,a5
    80004b20:	70b2                	ld	ra,296(sp)
    80004b22:	7412                	ld	s0,288(sp)
    80004b24:	64f2                	ld	s1,280(sp)
    80004b26:	6952                	ld	s2,272(sp)
    80004b28:	6155                	addi	sp,sp,304
    80004b2a:	8082                	ret

0000000080004b2c <sys_unlink>:
{
    80004b2c:	7151                	addi	sp,sp,-240
    80004b2e:	f586                	sd	ra,232(sp)
    80004b30:	f1a2                	sd	s0,224(sp)
    80004b32:	eda6                	sd	s1,216(sp)
    80004b34:	e9ca                	sd	s2,208(sp)
    80004b36:	e5ce                	sd	s3,200(sp)
    80004b38:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004b3a:	08000613          	li	a2,128
    80004b3e:	f3040593          	addi	a1,s0,-208
    80004b42:	4501                	li	a0,0
    80004b44:	ffffd097          	auipc	ra,0xffffd
    80004b48:	614080e7          	jalr	1556(ra) # 80002158 <argstr>
    80004b4c:	18054163          	bltz	a0,80004cce <sys_unlink+0x1a2>
  begin_op();
    80004b50:	fffff097          	auipc	ra,0xfffff
    80004b54:	bde080e7          	jalr	-1058(ra) # 8000372e <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004b58:	fb040593          	addi	a1,s0,-80
    80004b5c:	f3040513          	addi	a0,s0,-208
    80004b60:	fffff097          	auipc	ra,0xfffff
    80004b64:	9d0080e7          	jalr	-1584(ra) # 80003530 <nameiparent>
    80004b68:	84aa                	mv	s1,a0
    80004b6a:	c979                	beqz	a0,80004c40 <sys_unlink+0x114>
  ilock(dp);
    80004b6c:	ffffe097          	auipc	ra,0xffffe
    80004b70:	200080e7          	jalr	512(ra) # 80002d6c <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004b74:	00004597          	auipc	a1,0x4
    80004b78:	ba458593          	addi	a1,a1,-1116 # 80008718 <syscalls+0x2e8>
    80004b7c:	fb040513          	addi	a0,s0,-80
    80004b80:	ffffe097          	auipc	ra,0xffffe
    80004b84:	6b6080e7          	jalr	1718(ra) # 80003236 <namecmp>
    80004b88:	14050a63          	beqz	a0,80004cdc <sys_unlink+0x1b0>
    80004b8c:	00004597          	auipc	a1,0x4
    80004b90:	b9458593          	addi	a1,a1,-1132 # 80008720 <syscalls+0x2f0>
    80004b94:	fb040513          	addi	a0,s0,-80
    80004b98:	ffffe097          	auipc	ra,0xffffe
    80004b9c:	69e080e7          	jalr	1694(ra) # 80003236 <namecmp>
    80004ba0:	12050e63          	beqz	a0,80004cdc <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004ba4:	f2c40613          	addi	a2,s0,-212
    80004ba8:	fb040593          	addi	a1,s0,-80
    80004bac:	8526                	mv	a0,s1
    80004bae:	ffffe097          	auipc	ra,0xffffe
    80004bb2:	6a2080e7          	jalr	1698(ra) # 80003250 <dirlookup>
    80004bb6:	892a                	mv	s2,a0
    80004bb8:	12050263          	beqz	a0,80004cdc <sys_unlink+0x1b0>
  ilock(ip);
    80004bbc:	ffffe097          	auipc	ra,0xffffe
    80004bc0:	1b0080e7          	jalr	432(ra) # 80002d6c <ilock>
  if(ip->nlink < 1)
    80004bc4:	04a91783          	lh	a5,74(s2)
    80004bc8:	08f05263          	blez	a5,80004c4c <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004bcc:	04491703          	lh	a4,68(s2)
    80004bd0:	4785                	li	a5,1
    80004bd2:	08f70563          	beq	a4,a5,80004c5c <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004bd6:	4641                	li	a2,16
    80004bd8:	4581                	li	a1,0
    80004bda:	fc040513          	addi	a0,s0,-64
    80004bde:	ffffb097          	auipc	ra,0xffffb
    80004be2:	59a080e7          	jalr	1434(ra) # 80000178 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004be6:	4741                	li	a4,16
    80004be8:	f2c42683          	lw	a3,-212(s0)
    80004bec:	fc040613          	addi	a2,s0,-64
    80004bf0:	4581                	li	a1,0
    80004bf2:	8526                	mv	a0,s1
    80004bf4:	ffffe097          	auipc	ra,0xffffe
    80004bf8:	524080e7          	jalr	1316(ra) # 80003118 <writei>
    80004bfc:	47c1                	li	a5,16
    80004bfe:	0af51563          	bne	a0,a5,80004ca8 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004c02:	04491703          	lh	a4,68(s2)
    80004c06:	4785                	li	a5,1
    80004c08:	0af70863          	beq	a4,a5,80004cb8 <sys_unlink+0x18c>
  iunlockput(dp);
    80004c0c:	8526                	mv	a0,s1
    80004c0e:	ffffe097          	auipc	ra,0xffffe
    80004c12:	3c0080e7          	jalr	960(ra) # 80002fce <iunlockput>
  ip->nlink--;
    80004c16:	04a95783          	lhu	a5,74(s2)
    80004c1a:	37fd                	addiw	a5,a5,-1
    80004c1c:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004c20:	854a                	mv	a0,s2
    80004c22:	ffffe097          	auipc	ra,0xffffe
    80004c26:	080080e7          	jalr	128(ra) # 80002ca2 <iupdate>
  iunlockput(ip);
    80004c2a:	854a                	mv	a0,s2
    80004c2c:	ffffe097          	auipc	ra,0xffffe
    80004c30:	3a2080e7          	jalr	930(ra) # 80002fce <iunlockput>
  end_op();
    80004c34:	fffff097          	auipc	ra,0xfffff
    80004c38:	b7a080e7          	jalr	-1158(ra) # 800037ae <end_op>
  return 0;
    80004c3c:	4501                	li	a0,0
    80004c3e:	a84d                	j	80004cf0 <sys_unlink+0x1c4>
    end_op();
    80004c40:	fffff097          	auipc	ra,0xfffff
    80004c44:	b6e080e7          	jalr	-1170(ra) # 800037ae <end_op>
    return -1;
    80004c48:	557d                	li	a0,-1
    80004c4a:	a05d                	j	80004cf0 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004c4c:	00004517          	auipc	a0,0x4
    80004c50:	adc50513          	addi	a0,a0,-1316 # 80008728 <syscalls+0x2f8>
    80004c54:	00001097          	auipc	ra,0x1
    80004c58:	21e080e7          	jalr	542(ra) # 80005e72 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004c5c:	04c92703          	lw	a4,76(s2)
    80004c60:	02000793          	li	a5,32
    80004c64:	f6e7f9e3          	bgeu	a5,a4,80004bd6 <sys_unlink+0xaa>
    80004c68:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004c6c:	4741                	li	a4,16
    80004c6e:	86ce                	mv	a3,s3
    80004c70:	f1840613          	addi	a2,s0,-232
    80004c74:	4581                	li	a1,0
    80004c76:	854a                	mv	a0,s2
    80004c78:	ffffe097          	auipc	ra,0xffffe
    80004c7c:	3a8080e7          	jalr	936(ra) # 80003020 <readi>
    80004c80:	47c1                	li	a5,16
    80004c82:	00f51b63          	bne	a0,a5,80004c98 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004c86:	f1845783          	lhu	a5,-232(s0)
    80004c8a:	e7a1                	bnez	a5,80004cd2 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004c8c:	29c1                	addiw	s3,s3,16
    80004c8e:	04c92783          	lw	a5,76(s2)
    80004c92:	fcf9ede3          	bltu	s3,a5,80004c6c <sys_unlink+0x140>
    80004c96:	b781                	j	80004bd6 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004c98:	00004517          	auipc	a0,0x4
    80004c9c:	aa850513          	addi	a0,a0,-1368 # 80008740 <syscalls+0x310>
    80004ca0:	00001097          	auipc	ra,0x1
    80004ca4:	1d2080e7          	jalr	466(ra) # 80005e72 <panic>
    panic("unlink: writei");
    80004ca8:	00004517          	auipc	a0,0x4
    80004cac:	ab050513          	addi	a0,a0,-1360 # 80008758 <syscalls+0x328>
    80004cb0:	00001097          	auipc	ra,0x1
    80004cb4:	1c2080e7          	jalr	450(ra) # 80005e72 <panic>
    dp->nlink--;
    80004cb8:	04a4d783          	lhu	a5,74(s1)
    80004cbc:	37fd                	addiw	a5,a5,-1
    80004cbe:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004cc2:	8526                	mv	a0,s1
    80004cc4:	ffffe097          	auipc	ra,0xffffe
    80004cc8:	fde080e7          	jalr	-34(ra) # 80002ca2 <iupdate>
    80004ccc:	b781                	j	80004c0c <sys_unlink+0xe0>
    return -1;
    80004cce:	557d                	li	a0,-1
    80004cd0:	a005                	j	80004cf0 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004cd2:	854a                	mv	a0,s2
    80004cd4:	ffffe097          	auipc	ra,0xffffe
    80004cd8:	2fa080e7          	jalr	762(ra) # 80002fce <iunlockput>
  iunlockput(dp);
    80004cdc:	8526                	mv	a0,s1
    80004cde:	ffffe097          	auipc	ra,0xffffe
    80004ce2:	2f0080e7          	jalr	752(ra) # 80002fce <iunlockput>
  end_op();
    80004ce6:	fffff097          	auipc	ra,0xfffff
    80004cea:	ac8080e7          	jalr	-1336(ra) # 800037ae <end_op>
  return -1;
    80004cee:	557d                	li	a0,-1
}
    80004cf0:	70ae                	ld	ra,232(sp)
    80004cf2:	740e                	ld	s0,224(sp)
    80004cf4:	64ee                	ld	s1,216(sp)
    80004cf6:	694e                	ld	s2,208(sp)
    80004cf8:	69ae                	ld	s3,200(sp)
    80004cfa:	616d                	addi	sp,sp,240
    80004cfc:	8082                	ret

0000000080004cfe <sys_open>:

uint64
sys_open(void)
{
    80004cfe:	7131                	addi	sp,sp,-192
    80004d00:	fd06                	sd	ra,184(sp)
    80004d02:	f922                	sd	s0,176(sp)
    80004d04:	f526                	sd	s1,168(sp)
    80004d06:	f14a                	sd	s2,160(sp)
    80004d08:	ed4e                	sd	s3,152(sp)
    80004d0a:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004d0c:	f4c40593          	addi	a1,s0,-180
    80004d10:	4505                	li	a0,1
    80004d12:	ffffd097          	auipc	ra,0xffffd
    80004d16:	406080e7          	jalr	1030(ra) # 80002118 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004d1a:	08000613          	li	a2,128
    80004d1e:	f5040593          	addi	a1,s0,-176
    80004d22:	4501                	li	a0,0
    80004d24:	ffffd097          	auipc	ra,0xffffd
    80004d28:	434080e7          	jalr	1076(ra) # 80002158 <argstr>
    80004d2c:	87aa                	mv	a5,a0
    return -1;
    80004d2e:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004d30:	0a07c963          	bltz	a5,80004de2 <sys_open+0xe4>

  begin_op();
    80004d34:	fffff097          	auipc	ra,0xfffff
    80004d38:	9fa080e7          	jalr	-1542(ra) # 8000372e <begin_op>

  if(omode & O_CREATE){
    80004d3c:	f4c42783          	lw	a5,-180(s0)
    80004d40:	2007f793          	andi	a5,a5,512
    80004d44:	cfc5                	beqz	a5,80004dfc <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004d46:	4681                	li	a3,0
    80004d48:	4601                	li	a2,0
    80004d4a:	4589                	li	a1,2
    80004d4c:	f5040513          	addi	a0,s0,-176
    80004d50:	00000097          	auipc	ra,0x0
    80004d54:	974080e7          	jalr	-1676(ra) # 800046c4 <create>
    80004d58:	84aa                	mv	s1,a0
    if(ip == 0){
    80004d5a:	c959                	beqz	a0,80004df0 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004d5c:	04449703          	lh	a4,68(s1)
    80004d60:	478d                	li	a5,3
    80004d62:	00f71763          	bne	a4,a5,80004d70 <sys_open+0x72>
    80004d66:	0464d703          	lhu	a4,70(s1)
    80004d6a:	47a5                	li	a5,9
    80004d6c:	0ce7ed63          	bltu	a5,a4,80004e46 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004d70:	fffff097          	auipc	ra,0xfffff
    80004d74:	dce080e7          	jalr	-562(ra) # 80003b3e <filealloc>
    80004d78:	89aa                	mv	s3,a0
    80004d7a:	10050363          	beqz	a0,80004e80 <sys_open+0x182>
    80004d7e:	00000097          	auipc	ra,0x0
    80004d82:	904080e7          	jalr	-1788(ra) # 80004682 <fdalloc>
    80004d86:	892a                	mv	s2,a0
    80004d88:	0e054763          	bltz	a0,80004e76 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004d8c:	04449703          	lh	a4,68(s1)
    80004d90:	478d                	li	a5,3
    80004d92:	0cf70563          	beq	a4,a5,80004e5c <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004d96:	4789                	li	a5,2
    80004d98:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004d9c:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004da0:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004da4:	f4c42783          	lw	a5,-180(s0)
    80004da8:	0017c713          	xori	a4,a5,1
    80004dac:	8b05                	andi	a4,a4,1
    80004dae:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004db2:	0037f713          	andi	a4,a5,3
    80004db6:	00e03733          	snez	a4,a4
    80004dba:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004dbe:	4007f793          	andi	a5,a5,1024
    80004dc2:	c791                	beqz	a5,80004dce <sys_open+0xd0>
    80004dc4:	04449703          	lh	a4,68(s1)
    80004dc8:	4789                	li	a5,2
    80004dca:	0af70063          	beq	a4,a5,80004e6a <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004dce:	8526                	mv	a0,s1
    80004dd0:	ffffe097          	auipc	ra,0xffffe
    80004dd4:	05e080e7          	jalr	94(ra) # 80002e2e <iunlock>
  end_op();
    80004dd8:	fffff097          	auipc	ra,0xfffff
    80004ddc:	9d6080e7          	jalr	-1578(ra) # 800037ae <end_op>

  return fd;
    80004de0:	854a                	mv	a0,s2
}
    80004de2:	70ea                	ld	ra,184(sp)
    80004de4:	744a                	ld	s0,176(sp)
    80004de6:	74aa                	ld	s1,168(sp)
    80004de8:	790a                	ld	s2,160(sp)
    80004dea:	69ea                	ld	s3,152(sp)
    80004dec:	6129                	addi	sp,sp,192
    80004dee:	8082                	ret
      end_op();
    80004df0:	fffff097          	auipc	ra,0xfffff
    80004df4:	9be080e7          	jalr	-1602(ra) # 800037ae <end_op>
      return -1;
    80004df8:	557d                	li	a0,-1
    80004dfa:	b7e5                	j	80004de2 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004dfc:	f5040513          	addi	a0,s0,-176
    80004e00:	ffffe097          	auipc	ra,0xffffe
    80004e04:	712080e7          	jalr	1810(ra) # 80003512 <namei>
    80004e08:	84aa                	mv	s1,a0
    80004e0a:	c905                	beqz	a0,80004e3a <sys_open+0x13c>
    ilock(ip);
    80004e0c:	ffffe097          	auipc	ra,0xffffe
    80004e10:	f60080e7          	jalr	-160(ra) # 80002d6c <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004e14:	04449703          	lh	a4,68(s1)
    80004e18:	4785                	li	a5,1
    80004e1a:	f4f711e3          	bne	a4,a5,80004d5c <sys_open+0x5e>
    80004e1e:	f4c42783          	lw	a5,-180(s0)
    80004e22:	d7b9                	beqz	a5,80004d70 <sys_open+0x72>
      iunlockput(ip);
    80004e24:	8526                	mv	a0,s1
    80004e26:	ffffe097          	auipc	ra,0xffffe
    80004e2a:	1a8080e7          	jalr	424(ra) # 80002fce <iunlockput>
      end_op();
    80004e2e:	fffff097          	auipc	ra,0xfffff
    80004e32:	980080e7          	jalr	-1664(ra) # 800037ae <end_op>
      return -1;
    80004e36:	557d                	li	a0,-1
    80004e38:	b76d                	j	80004de2 <sys_open+0xe4>
      end_op();
    80004e3a:	fffff097          	auipc	ra,0xfffff
    80004e3e:	974080e7          	jalr	-1676(ra) # 800037ae <end_op>
      return -1;
    80004e42:	557d                	li	a0,-1
    80004e44:	bf79                	j	80004de2 <sys_open+0xe4>
    iunlockput(ip);
    80004e46:	8526                	mv	a0,s1
    80004e48:	ffffe097          	auipc	ra,0xffffe
    80004e4c:	186080e7          	jalr	390(ra) # 80002fce <iunlockput>
    end_op();
    80004e50:	fffff097          	auipc	ra,0xfffff
    80004e54:	95e080e7          	jalr	-1698(ra) # 800037ae <end_op>
    return -1;
    80004e58:	557d                	li	a0,-1
    80004e5a:	b761                	j	80004de2 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004e5c:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004e60:	04649783          	lh	a5,70(s1)
    80004e64:	02f99223          	sh	a5,36(s3)
    80004e68:	bf25                	j	80004da0 <sys_open+0xa2>
    itrunc(ip);
    80004e6a:	8526                	mv	a0,s1
    80004e6c:	ffffe097          	auipc	ra,0xffffe
    80004e70:	00e080e7          	jalr	14(ra) # 80002e7a <itrunc>
    80004e74:	bfa9                	j	80004dce <sys_open+0xd0>
      fileclose(f);
    80004e76:	854e                	mv	a0,s3
    80004e78:	fffff097          	auipc	ra,0xfffff
    80004e7c:	d82080e7          	jalr	-638(ra) # 80003bfa <fileclose>
    iunlockput(ip);
    80004e80:	8526                	mv	a0,s1
    80004e82:	ffffe097          	auipc	ra,0xffffe
    80004e86:	14c080e7          	jalr	332(ra) # 80002fce <iunlockput>
    end_op();
    80004e8a:	fffff097          	auipc	ra,0xfffff
    80004e8e:	924080e7          	jalr	-1756(ra) # 800037ae <end_op>
    return -1;
    80004e92:	557d                	li	a0,-1
    80004e94:	b7b9                	j	80004de2 <sys_open+0xe4>

0000000080004e96 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004e96:	7175                	addi	sp,sp,-144
    80004e98:	e506                	sd	ra,136(sp)
    80004e9a:	e122                	sd	s0,128(sp)
    80004e9c:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004e9e:	fffff097          	auipc	ra,0xfffff
    80004ea2:	890080e7          	jalr	-1904(ra) # 8000372e <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004ea6:	08000613          	li	a2,128
    80004eaa:	f7040593          	addi	a1,s0,-144
    80004eae:	4501                	li	a0,0
    80004eb0:	ffffd097          	auipc	ra,0xffffd
    80004eb4:	2a8080e7          	jalr	680(ra) # 80002158 <argstr>
    80004eb8:	02054963          	bltz	a0,80004eea <sys_mkdir+0x54>
    80004ebc:	4681                	li	a3,0
    80004ebe:	4601                	li	a2,0
    80004ec0:	4585                	li	a1,1
    80004ec2:	f7040513          	addi	a0,s0,-144
    80004ec6:	fffff097          	auipc	ra,0xfffff
    80004eca:	7fe080e7          	jalr	2046(ra) # 800046c4 <create>
    80004ece:	cd11                	beqz	a0,80004eea <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004ed0:	ffffe097          	auipc	ra,0xffffe
    80004ed4:	0fe080e7          	jalr	254(ra) # 80002fce <iunlockput>
  end_op();
    80004ed8:	fffff097          	auipc	ra,0xfffff
    80004edc:	8d6080e7          	jalr	-1834(ra) # 800037ae <end_op>
  return 0;
    80004ee0:	4501                	li	a0,0
}
    80004ee2:	60aa                	ld	ra,136(sp)
    80004ee4:	640a                	ld	s0,128(sp)
    80004ee6:	6149                	addi	sp,sp,144
    80004ee8:	8082                	ret
    end_op();
    80004eea:	fffff097          	auipc	ra,0xfffff
    80004eee:	8c4080e7          	jalr	-1852(ra) # 800037ae <end_op>
    return -1;
    80004ef2:	557d                	li	a0,-1
    80004ef4:	b7fd                	j	80004ee2 <sys_mkdir+0x4c>

0000000080004ef6 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004ef6:	7135                	addi	sp,sp,-160
    80004ef8:	ed06                	sd	ra,152(sp)
    80004efa:	e922                	sd	s0,144(sp)
    80004efc:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004efe:	fffff097          	auipc	ra,0xfffff
    80004f02:	830080e7          	jalr	-2000(ra) # 8000372e <begin_op>
  argint(1, &major);
    80004f06:	f6c40593          	addi	a1,s0,-148
    80004f0a:	4505                	li	a0,1
    80004f0c:	ffffd097          	auipc	ra,0xffffd
    80004f10:	20c080e7          	jalr	524(ra) # 80002118 <argint>
  argint(2, &minor);
    80004f14:	f6840593          	addi	a1,s0,-152
    80004f18:	4509                	li	a0,2
    80004f1a:	ffffd097          	auipc	ra,0xffffd
    80004f1e:	1fe080e7          	jalr	510(ra) # 80002118 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004f22:	08000613          	li	a2,128
    80004f26:	f7040593          	addi	a1,s0,-144
    80004f2a:	4501                	li	a0,0
    80004f2c:	ffffd097          	auipc	ra,0xffffd
    80004f30:	22c080e7          	jalr	556(ra) # 80002158 <argstr>
    80004f34:	02054b63          	bltz	a0,80004f6a <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004f38:	f6841683          	lh	a3,-152(s0)
    80004f3c:	f6c41603          	lh	a2,-148(s0)
    80004f40:	458d                	li	a1,3
    80004f42:	f7040513          	addi	a0,s0,-144
    80004f46:	fffff097          	auipc	ra,0xfffff
    80004f4a:	77e080e7          	jalr	1918(ra) # 800046c4 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004f4e:	cd11                	beqz	a0,80004f6a <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004f50:	ffffe097          	auipc	ra,0xffffe
    80004f54:	07e080e7          	jalr	126(ra) # 80002fce <iunlockput>
  end_op();
    80004f58:	fffff097          	auipc	ra,0xfffff
    80004f5c:	856080e7          	jalr	-1962(ra) # 800037ae <end_op>
  return 0;
    80004f60:	4501                	li	a0,0
}
    80004f62:	60ea                	ld	ra,152(sp)
    80004f64:	644a                	ld	s0,144(sp)
    80004f66:	610d                	addi	sp,sp,160
    80004f68:	8082                	ret
    end_op();
    80004f6a:	fffff097          	auipc	ra,0xfffff
    80004f6e:	844080e7          	jalr	-1980(ra) # 800037ae <end_op>
    return -1;
    80004f72:	557d                	li	a0,-1
    80004f74:	b7fd                	j	80004f62 <sys_mknod+0x6c>

0000000080004f76 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004f76:	7135                	addi	sp,sp,-160
    80004f78:	ed06                	sd	ra,152(sp)
    80004f7a:	e922                	sd	s0,144(sp)
    80004f7c:	e526                	sd	s1,136(sp)
    80004f7e:	e14a                	sd	s2,128(sp)
    80004f80:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004f82:	ffffc097          	auipc	ra,0xffffc
    80004f86:	fbe080e7          	jalr	-66(ra) # 80000f40 <myproc>
    80004f8a:	892a                	mv	s2,a0
  
  begin_op();
    80004f8c:	ffffe097          	auipc	ra,0xffffe
    80004f90:	7a2080e7          	jalr	1954(ra) # 8000372e <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004f94:	08000613          	li	a2,128
    80004f98:	f6040593          	addi	a1,s0,-160
    80004f9c:	4501                	li	a0,0
    80004f9e:	ffffd097          	auipc	ra,0xffffd
    80004fa2:	1ba080e7          	jalr	442(ra) # 80002158 <argstr>
    80004fa6:	04054b63          	bltz	a0,80004ffc <sys_chdir+0x86>
    80004faa:	f6040513          	addi	a0,s0,-160
    80004fae:	ffffe097          	auipc	ra,0xffffe
    80004fb2:	564080e7          	jalr	1380(ra) # 80003512 <namei>
    80004fb6:	84aa                	mv	s1,a0
    80004fb8:	c131                	beqz	a0,80004ffc <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004fba:	ffffe097          	auipc	ra,0xffffe
    80004fbe:	db2080e7          	jalr	-590(ra) # 80002d6c <ilock>
  if(ip->type != T_DIR){
    80004fc2:	04449703          	lh	a4,68(s1)
    80004fc6:	4785                	li	a5,1
    80004fc8:	04f71063          	bne	a4,a5,80005008 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004fcc:	8526                	mv	a0,s1
    80004fce:	ffffe097          	auipc	ra,0xffffe
    80004fd2:	e60080e7          	jalr	-416(ra) # 80002e2e <iunlock>
  iput(p->cwd);
    80004fd6:	15093503          	ld	a0,336(s2)
    80004fda:	ffffe097          	auipc	ra,0xffffe
    80004fde:	f4c080e7          	jalr	-180(ra) # 80002f26 <iput>
  end_op();
    80004fe2:	ffffe097          	auipc	ra,0xffffe
    80004fe6:	7cc080e7          	jalr	1996(ra) # 800037ae <end_op>
  p->cwd = ip;
    80004fea:	14993823          	sd	s1,336(s2)
  return 0;
    80004fee:	4501                	li	a0,0
}
    80004ff0:	60ea                	ld	ra,152(sp)
    80004ff2:	644a                	ld	s0,144(sp)
    80004ff4:	64aa                	ld	s1,136(sp)
    80004ff6:	690a                	ld	s2,128(sp)
    80004ff8:	610d                	addi	sp,sp,160
    80004ffa:	8082                	ret
    end_op();
    80004ffc:	ffffe097          	auipc	ra,0xffffe
    80005000:	7b2080e7          	jalr	1970(ra) # 800037ae <end_op>
    return -1;
    80005004:	557d                	li	a0,-1
    80005006:	b7ed                	j	80004ff0 <sys_chdir+0x7a>
    iunlockput(ip);
    80005008:	8526                	mv	a0,s1
    8000500a:	ffffe097          	auipc	ra,0xffffe
    8000500e:	fc4080e7          	jalr	-60(ra) # 80002fce <iunlockput>
    end_op();
    80005012:	ffffe097          	auipc	ra,0xffffe
    80005016:	79c080e7          	jalr	1948(ra) # 800037ae <end_op>
    return -1;
    8000501a:	557d                	li	a0,-1
    8000501c:	bfd1                	j	80004ff0 <sys_chdir+0x7a>

000000008000501e <sys_exec>:

uint64
sys_exec(void)
{
    8000501e:	7145                	addi	sp,sp,-464
    80005020:	e786                	sd	ra,456(sp)
    80005022:	e3a2                	sd	s0,448(sp)
    80005024:	ff26                	sd	s1,440(sp)
    80005026:	fb4a                	sd	s2,432(sp)
    80005028:	f74e                	sd	s3,424(sp)
    8000502a:	f352                	sd	s4,416(sp)
    8000502c:	ef56                	sd	s5,408(sp)
    8000502e:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005030:	e3840593          	addi	a1,s0,-456
    80005034:	4505                	li	a0,1
    80005036:	ffffd097          	auipc	ra,0xffffd
    8000503a:	102080e7          	jalr	258(ra) # 80002138 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    8000503e:	08000613          	li	a2,128
    80005042:	f4040593          	addi	a1,s0,-192
    80005046:	4501                	li	a0,0
    80005048:	ffffd097          	auipc	ra,0xffffd
    8000504c:	110080e7          	jalr	272(ra) # 80002158 <argstr>
    80005050:	87aa                	mv	a5,a0
    return -1;
    80005052:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80005054:	0c07c263          	bltz	a5,80005118 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80005058:	10000613          	li	a2,256
    8000505c:	4581                	li	a1,0
    8000505e:	e4040513          	addi	a0,s0,-448
    80005062:	ffffb097          	auipc	ra,0xffffb
    80005066:	116080e7          	jalr	278(ra) # 80000178 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    8000506a:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    8000506e:	89a6                	mv	s3,s1
    80005070:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005072:	02000a13          	li	s4,32
    80005076:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    8000507a:	00391513          	slli	a0,s2,0x3
    8000507e:	e3040593          	addi	a1,s0,-464
    80005082:	e3843783          	ld	a5,-456(s0)
    80005086:	953e                	add	a0,a0,a5
    80005088:	ffffd097          	auipc	ra,0xffffd
    8000508c:	ff2080e7          	jalr	-14(ra) # 8000207a <fetchaddr>
    80005090:	02054a63          	bltz	a0,800050c4 <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    80005094:	e3043783          	ld	a5,-464(s0)
    80005098:	c3b9                	beqz	a5,800050de <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    8000509a:	ffffb097          	auipc	ra,0xffffb
    8000509e:	07e080e7          	jalr	126(ra) # 80000118 <kalloc>
    800050a2:	85aa                	mv	a1,a0
    800050a4:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800050a8:	cd11                	beqz	a0,800050c4 <sys_exec+0xa6>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800050aa:	6605                	lui	a2,0x1
    800050ac:	e3043503          	ld	a0,-464(s0)
    800050b0:	ffffd097          	auipc	ra,0xffffd
    800050b4:	01c080e7          	jalr	28(ra) # 800020cc <fetchstr>
    800050b8:	00054663          	bltz	a0,800050c4 <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    800050bc:	0905                	addi	s2,s2,1
    800050be:	09a1                	addi	s3,s3,8
    800050c0:	fb491be3          	bne	s2,s4,80005076 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050c4:	10048913          	addi	s2,s1,256
    800050c8:	6088                	ld	a0,0(s1)
    800050ca:	c531                	beqz	a0,80005116 <sys_exec+0xf8>
    kfree(argv[i]);
    800050cc:	ffffb097          	auipc	ra,0xffffb
    800050d0:	f50080e7          	jalr	-176(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050d4:	04a1                	addi	s1,s1,8
    800050d6:	ff2499e3          	bne	s1,s2,800050c8 <sys_exec+0xaa>
  return -1;
    800050da:	557d                	li	a0,-1
    800050dc:	a835                	j	80005118 <sys_exec+0xfa>
      argv[i] = 0;
    800050de:	0a8e                	slli	s5,s5,0x3
    800050e0:	fc040793          	addi	a5,s0,-64
    800050e4:	9abe                	add	s5,s5,a5
    800050e6:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    800050ea:	e4040593          	addi	a1,s0,-448
    800050ee:	f4040513          	addi	a0,s0,-192
    800050f2:	fffff097          	auipc	ra,0xfffff
    800050f6:	190080e7          	jalr	400(ra) # 80004282 <exec>
    800050fa:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050fc:	10048993          	addi	s3,s1,256
    80005100:	6088                	ld	a0,0(s1)
    80005102:	c901                	beqz	a0,80005112 <sys_exec+0xf4>
    kfree(argv[i]);
    80005104:	ffffb097          	auipc	ra,0xffffb
    80005108:	f18080e7          	jalr	-232(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000510c:	04a1                	addi	s1,s1,8
    8000510e:	ff3499e3          	bne	s1,s3,80005100 <sys_exec+0xe2>
  return ret;
    80005112:	854a                	mv	a0,s2
    80005114:	a011                	j	80005118 <sys_exec+0xfa>
  return -1;
    80005116:	557d                	li	a0,-1
}
    80005118:	60be                	ld	ra,456(sp)
    8000511a:	641e                	ld	s0,448(sp)
    8000511c:	74fa                	ld	s1,440(sp)
    8000511e:	795a                	ld	s2,432(sp)
    80005120:	79ba                	ld	s3,424(sp)
    80005122:	7a1a                	ld	s4,416(sp)
    80005124:	6afa                	ld	s5,408(sp)
    80005126:	6179                	addi	sp,sp,464
    80005128:	8082                	ret

000000008000512a <sys_pipe>:

uint64
sys_pipe(void)
{
    8000512a:	7139                	addi	sp,sp,-64
    8000512c:	fc06                	sd	ra,56(sp)
    8000512e:	f822                	sd	s0,48(sp)
    80005130:	f426                	sd	s1,40(sp)
    80005132:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005134:	ffffc097          	auipc	ra,0xffffc
    80005138:	e0c080e7          	jalr	-500(ra) # 80000f40 <myproc>
    8000513c:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    8000513e:	fd840593          	addi	a1,s0,-40
    80005142:	4501                	li	a0,0
    80005144:	ffffd097          	auipc	ra,0xffffd
    80005148:	ff4080e7          	jalr	-12(ra) # 80002138 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    8000514c:	fc840593          	addi	a1,s0,-56
    80005150:	fd040513          	addi	a0,s0,-48
    80005154:	fffff097          	auipc	ra,0xfffff
    80005158:	dd6080e7          	jalr	-554(ra) # 80003f2a <pipealloc>
    return -1;
    8000515c:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    8000515e:	0c054463          	bltz	a0,80005226 <sys_pipe+0xfc>
  fd0 = -1;
    80005162:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005166:	fd043503          	ld	a0,-48(s0)
    8000516a:	fffff097          	auipc	ra,0xfffff
    8000516e:	518080e7          	jalr	1304(ra) # 80004682 <fdalloc>
    80005172:	fca42223          	sw	a0,-60(s0)
    80005176:	08054b63          	bltz	a0,8000520c <sys_pipe+0xe2>
    8000517a:	fc843503          	ld	a0,-56(s0)
    8000517e:	fffff097          	auipc	ra,0xfffff
    80005182:	504080e7          	jalr	1284(ra) # 80004682 <fdalloc>
    80005186:	fca42023          	sw	a0,-64(s0)
    8000518a:	06054863          	bltz	a0,800051fa <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000518e:	4691                	li	a3,4
    80005190:	fc440613          	addi	a2,s0,-60
    80005194:	fd843583          	ld	a1,-40(s0)
    80005198:	68a8                	ld	a0,80(s1)
    8000519a:	ffffc097          	auipc	ra,0xffffc
    8000519e:	97c080e7          	jalr	-1668(ra) # 80000b16 <copyout>
    800051a2:	02054063          	bltz	a0,800051c2 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800051a6:	4691                	li	a3,4
    800051a8:	fc040613          	addi	a2,s0,-64
    800051ac:	fd843583          	ld	a1,-40(s0)
    800051b0:	0591                	addi	a1,a1,4
    800051b2:	68a8                	ld	a0,80(s1)
    800051b4:	ffffc097          	auipc	ra,0xffffc
    800051b8:	962080e7          	jalr	-1694(ra) # 80000b16 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800051bc:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800051be:	06055463          	bgez	a0,80005226 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    800051c2:	fc442783          	lw	a5,-60(s0)
    800051c6:	07e9                	addi	a5,a5,26
    800051c8:	078e                	slli	a5,a5,0x3
    800051ca:	97a6                	add	a5,a5,s1
    800051cc:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800051d0:	fc042503          	lw	a0,-64(s0)
    800051d4:	0569                	addi	a0,a0,26
    800051d6:	050e                	slli	a0,a0,0x3
    800051d8:	94aa                	add	s1,s1,a0
    800051da:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800051de:	fd043503          	ld	a0,-48(s0)
    800051e2:	fffff097          	auipc	ra,0xfffff
    800051e6:	a18080e7          	jalr	-1512(ra) # 80003bfa <fileclose>
    fileclose(wf);
    800051ea:	fc843503          	ld	a0,-56(s0)
    800051ee:	fffff097          	auipc	ra,0xfffff
    800051f2:	a0c080e7          	jalr	-1524(ra) # 80003bfa <fileclose>
    return -1;
    800051f6:	57fd                	li	a5,-1
    800051f8:	a03d                	j	80005226 <sys_pipe+0xfc>
    if(fd0 >= 0)
    800051fa:	fc442783          	lw	a5,-60(s0)
    800051fe:	0007c763          	bltz	a5,8000520c <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80005202:	07e9                	addi	a5,a5,26
    80005204:	078e                	slli	a5,a5,0x3
    80005206:	94be                	add	s1,s1,a5
    80005208:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    8000520c:	fd043503          	ld	a0,-48(s0)
    80005210:	fffff097          	auipc	ra,0xfffff
    80005214:	9ea080e7          	jalr	-1558(ra) # 80003bfa <fileclose>
    fileclose(wf);
    80005218:	fc843503          	ld	a0,-56(s0)
    8000521c:	fffff097          	auipc	ra,0xfffff
    80005220:	9de080e7          	jalr	-1570(ra) # 80003bfa <fileclose>
    return -1;
    80005224:	57fd                	li	a5,-1
}
    80005226:	853e                	mv	a0,a5
    80005228:	70e2                	ld	ra,56(sp)
    8000522a:	7442                	ld	s0,48(sp)
    8000522c:	74a2                	ld	s1,40(sp)
    8000522e:	6121                	addi	sp,sp,64
    80005230:	8082                	ret
	...

0000000080005240 <kernelvec>:
    80005240:	7111                	addi	sp,sp,-256
    80005242:	e006                	sd	ra,0(sp)
    80005244:	e40a                	sd	sp,8(sp)
    80005246:	e80e                	sd	gp,16(sp)
    80005248:	ec12                	sd	tp,24(sp)
    8000524a:	f016                	sd	t0,32(sp)
    8000524c:	f41a                	sd	t1,40(sp)
    8000524e:	f81e                	sd	t2,48(sp)
    80005250:	fc22                	sd	s0,56(sp)
    80005252:	e0a6                	sd	s1,64(sp)
    80005254:	e4aa                	sd	a0,72(sp)
    80005256:	e8ae                	sd	a1,80(sp)
    80005258:	ecb2                	sd	a2,88(sp)
    8000525a:	f0b6                	sd	a3,96(sp)
    8000525c:	f4ba                	sd	a4,104(sp)
    8000525e:	f8be                	sd	a5,112(sp)
    80005260:	fcc2                	sd	a6,120(sp)
    80005262:	e146                	sd	a7,128(sp)
    80005264:	e54a                	sd	s2,136(sp)
    80005266:	e94e                	sd	s3,144(sp)
    80005268:	ed52                	sd	s4,152(sp)
    8000526a:	f156                	sd	s5,160(sp)
    8000526c:	f55a                	sd	s6,168(sp)
    8000526e:	f95e                	sd	s7,176(sp)
    80005270:	fd62                	sd	s8,184(sp)
    80005272:	e1e6                	sd	s9,192(sp)
    80005274:	e5ea                	sd	s10,200(sp)
    80005276:	e9ee                	sd	s11,208(sp)
    80005278:	edf2                	sd	t3,216(sp)
    8000527a:	f1f6                	sd	t4,224(sp)
    8000527c:	f5fa                	sd	t5,232(sp)
    8000527e:	f9fe                	sd	t6,240(sp)
    80005280:	cc7fc0ef          	jal	ra,80001f46 <kerneltrap>
    80005284:	6082                	ld	ra,0(sp)
    80005286:	6122                	ld	sp,8(sp)
    80005288:	61c2                	ld	gp,16(sp)
    8000528a:	7282                	ld	t0,32(sp)
    8000528c:	7322                	ld	t1,40(sp)
    8000528e:	73c2                	ld	t2,48(sp)
    80005290:	7462                	ld	s0,56(sp)
    80005292:	6486                	ld	s1,64(sp)
    80005294:	6526                	ld	a0,72(sp)
    80005296:	65c6                	ld	a1,80(sp)
    80005298:	6666                	ld	a2,88(sp)
    8000529a:	7686                	ld	a3,96(sp)
    8000529c:	7726                	ld	a4,104(sp)
    8000529e:	77c6                	ld	a5,112(sp)
    800052a0:	7866                	ld	a6,120(sp)
    800052a2:	688a                	ld	a7,128(sp)
    800052a4:	692a                	ld	s2,136(sp)
    800052a6:	69ca                	ld	s3,144(sp)
    800052a8:	6a6a                	ld	s4,152(sp)
    800052aa:	7a8a                	ld	s5,160(sp)
    800052ac:	7b2a                	ld	s6,168(sp)
    800052ae:	7bca                	ld	s7,176(sp)
    800052b0:	7c6a                	ld	s8,184(sp)
    800052b2:	6c8e                	ld	s9,192(sp)
    800052b4:	6d2e                	ld	s10,200(sp)
    800052b6:	6dce                	ld	s11,208(sp)
    800052b8:	6e6e                	ld	t3,216(sp)
    800052ba:	7e8e                	ld	t4,224(sp)
    800052bc:	7f2e                	ld	t5,232(sp)
    800052be:	7fce                	ld	t6,240(sp)
    800052c0:	6111                	addi	sp,sp,256
    800052c2:	10200073          	sret
    800052c6:	00000013          	nop
    800052ca:	00000013          	nop
    800052ce:	0001                	nop

00000000800052d0 <timervec>:
    800052d0:	34051573          	csrrw	a0,mscratch,a0
    800052d4:	e10c                	sd	a1,0(a0)
    800052d6:	e510                	sd	a2,8(a0)
    800052d8:	e914                	sd	a3,16(a0)
    800052da:	6d0c                	ld	a1,24(a0)
    800052dc:	7110                	ld	a2,32(a0)
    800052de:	6194                	ld	a3,0(a1)
    800052e0:	96b2                	add	a3,a3,a2
    800052e2:	e194                	sd	a3,0(a1)
    800052e4:	4589                	li	a1,2
    800052e6:	14459073          	csrw	sip,a1
    800052ea:	6914                	ld	a3,16(a0)
    800052ec:	6510                	ld	a2,8(a0)
    800052ee:	610c                	ld	a1,0(a0)
    800052f0:	34051573          	csrrw	a0,mscratch,a0
    800052f4:	30200073          	mret
	...

00000000800052fa <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800052fa:	1141                	addi	sp,sp,-16
    800052fc:	e422                	sd	s0,8(sp)
    800052fe:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005300:	0c0007b7          	lui	a5,0xc000
    80005304:	4705                	li	a4,1
    80005306:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005308:	c3d8                	sw	a4,4(a5)
}
    8000530a:	6422                	ld	s0,8(sp)
    8000530c:	0141                	addi	sp,sp,16
    8000530e:	8082                	ret

0000000080005310 <plicinithart>:

void
plicinithart(void)
{
    80005310:	1141                	addi	sp,sp,-16
    80005312:	e406                	sd	ra,8(sp)
    80005314:	e022                	sd	s0,0(sp)
    80005316:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005318:	ffffc097          	auipc	ra,0xffffc
    8000531c:	bfc080e7          	jalr	-1028(ra) # 80000f14 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005320:	0085171b          	slliw	a4,a0,0x8
    80005324:	0c0027b7          	lui	a5,0xc002
    80005328:	97ba                	add	a5,a5,a4
    8000532a:	40200713          	li	a4,1026
    8000532e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005332:	00d5151b          	slliw	a0,a0,0xd
    80005336:	0c2017b7          	lui	a5,0xc201
    8000533a:	953e                	add	a0,a0,a5
    8000533c:	00052023          	sw	zero,0(a0)
}
    80005340:	60a2                	ld	ra,8(sp)
    80005342:	6402                	ld	s0,0(sp)
    80005344:	0141                	addi	sp,sp,16
    80005346:	8082                	ret

0000000080005348 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005348:	1141                	addi	sp,sp,-16
    8000534a:	e406                	sd	ra,8(sp)
    8000534c:	e022                	sd	s0,0(sp)
    8000534e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005350:	ffffc097          	auipc	ra,0xffffc
    80005354:	bc4080e7          	jalr	-1084(ra) # 80000f14 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005358:	00d5179b          	slliw	a5,a0,0xd
    8000535c:	0c201537          	lui	a0,0xc201
    80005360:	953e                	add	a0,a0,a5
  return irq;
}
    80005362:	4148                	lw	a0,4(a0)
    80005364:	60a2                	ld	ra,8(sp)
    80005366:	6402                	ld	s0,0(sp)
    80005368:	0141                	addi	sp,sp,16
    8000536a:	8082                	ret

000000008000536c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000536c:	1101                	addi	sp,sp,-32
    8000536e:	ec06                	sd	ra,24(sp)
    80005370:	e822                	sd	s0,16(sp)
    80005372:	e426                	sd	s1,8(sp)
    80005374:	1000                	addi	s0,sp,32
    80005376:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005378:	ffffc097          	auipc	ra,0xffffc
    8000537c:	b9c080e7          	jalr	-1124(ra) # 80000f14 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005380:	00d5151b          	slliw	a0,a0,0xd
    80005384:	0c2017b7          	lui	a5,0xc201
    80005388:	97aa                	add	a5,a5,a0
    8000538a:	c3c4                	sw	s1,4(a5)
}
    8000538c:	60e2                	ld	ra,24(sp)
    8000538e:	6442                	ld	s0,16(sp)
    80005390:	64a2                	ld	s1,8(sp)
    80005392:	6105                	addi	sp,sp,32
    80005394:	8082                	ret

0000000080005396 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005396:	1141                	addi	sp,sp,-16
    80005398:	e406                	sd	ra,8(sp)
    8000539a:	e022                	sd	s0,0(sp)
    8000539c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000539e:	479d                	li	a5,7
    800053a0:	04a7cc63          	blt	a5,a0,800053f8 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    800053a4:	00015797          	auipc	a5,0x15
    800053a8:	8dc78793          	addi	a5,a5,-1828 # 80019c80 <disk>
    800053ac:	97aa                	add	a5,a5,a0
    800053ae:	0187c783          	lbu	a5,24(a5)
    800053b2:	ebb9                	bnez	a5,80005408 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800053b4:	00451613          	slli	a2,a0,0x4
    800053b8:	00015797          	auipc	a5,0x15
    800053bc:	8c878793          	addi	a5,a5,-1848 # 80019c80 <disk>
    800053c0:	6394                	ld	a3,0(a5)
    800053c2:	96b2                	add	a3,a3,a2
    800053c4:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800053c8:	6398                	ld	a4,0(a5)
    800053ca:	9732                	add	a4,a4,a2
    800053cc:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800053d0:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800053d4:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800053d8:	953e                	add	a0,a0,a5
    800053da:	4785                	li	a5,1
    800053dc:	00f50c23          	sb	a5,24(a0) # c201018 <_entry-0x73dfefe8>
  wakeup(&disk.free[0]);
    800053e0:	00015517          	auipc	a0,0x15
    800053e4:	8b850513          	addi	a0,a0,-1864 # 80019c98 <disk+0x18>
    800053e8:	ffffc097          	auipc	ra,0xffffc
    800053ec:	328080e7          	jalr	808(ra) # 80001710 <wakeup>
}
    800053f0:	60a2                	ld	ra,8(sp)
    800053f2:	6402                	ld	s0,0(sp)
    800053f4:	0141                	addi	sp,sp,16
    800053f6:	8082                	ret
    panic("free_desc 1");
    800053f8:	00003517          	auipc	a0,0x3
    800053fc:	37050513          	addi	a0,a0,880 # 80008768 <syscalls+0x338>
    80005400:	00001097          	auipc	ra,0x1
    80005404:	a72080e7          	jalr	-1422(ra) # 80005e72 <panic>
    panic("free_desc 2");
    80005408:	00003517          	auipc	a0,0x3
    8000540c:	37050513          	addi	a0,a0,880 # 80008778 <syscalls+0x348>
    80005410:	00001097          	auipc	ra,0x1
    80005414:	a62080e7          	jalr	-1438(ra) # 80005e72 <panic>

0000000080005418 <virtio_disk_init>:
{
    80005418:	1101                	addi	sp,sp,-32
    8000541a:	ec06                	sd	ra,24(sp)
    8000541c:	e822                	sd	s0,16(sp)
    8000541e:	e426                	sd	s1,8(sp)
    80005420:	e04a                	sd	s2,0(sp)
    80005422:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005424:	00003597          	auipc	a1,0x3
    80005428:	36458593          	addi	a1,a1,868 # 80008788 <syscalls+0x358>
    8000542c:	00015517          	auipc	a0,0x15
    80005430:	97c50513          	addi	a0,a0,-1668 # 80019da8 <disk+0x128>
    80005434:	00001097          	auipc	ra,0x1
    80005438:	ef8080e7          	jalr	-264(ra) # 8000632c <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000543c:	100017b7          	lui	a5,0x10001
    80005440:	4398                	lw	a4,0(a5)
    80005442:	2701                	sext.w	a4,a4
    80005444:	747277b7          	lui	a5,0x74727
    80005448:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000544c:	14f71e63          	bne	a4,a5,800055a8 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005450:	100017b7          	lui	a5,0x10001
    80005454:	43dc                	lw	a5,4(a5)
    80005456:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005458:	4709                	li	a4,2
    8000545a:	14e79763          	bne	a5,a4,800055a8 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000545e:	100017b7          	lui	a5,0x10001
    80005462:	479c                	lw	a5,8(a5)
    80005464:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005466:	14e79163          	bne	a5,a4,800055a8 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000546a:	100017b7          	lui	a5,0x10001
    8000546e:	47d8                	lw	a4,12(a5)
    80005470:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005472:	554d47b7          	lui	a5,0x554d4
    80005476:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000547a:	12f71763          	bne	a4,a5,800055a8 <virtio_disk_init+0x190>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000547e:	100017b7          	lui	a5,0x10001
    80005482:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005486:	4705                	li	a4,1
    80005488:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000548a:	470d                	li	a4,3
    8000548c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000548e:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005490:	c7ffe737          	lui	a4,0xc7ffe
    80005494:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdc75f>
    80005498:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    8000549a:	2701                	sext.w	a4,a4
    8000549c:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000549e:	472d                	li	a4,11
    800054a0:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    800054a2:	0707a903          	lw	s2,112(a5)
    800054a6:	2901                	sext.w	s2,s2
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800054a8:	00897793          	andi	a5,s2,8
    800054ac:	10078663          	beqz	a5,800055b8 <virtio_disk_init+0x1a0>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800054b0:	100017b7          	lui	a5,0x10001
    800054b4:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    800054b8:	43fc                	lw	a5,68(a5)
    800054ba:	2781                	sext.w	a5,a5
    800054bc:	10079663          	bnez	a5,800055c8 <virtio_disk_init+0x1b0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800054c0:	100017b7          	lui	a5,0x10001
    800054c4:	5bdc                	lw	a5,52(a5)
    800054c6:	2781                	sext.w	a5,a5
  if(max == 0)
    800054c8:	10078863          	beqz	a5,800055d8 <virtio_disk_init+0x1c0>
  if(max < NUM)
    800054cc:	471d                	li	a4,7
    800054ce:	10f77d63          	bgeu	a4,a5,800055e8 <virtio_disk_init+0x1d0>
  disk.desc = kalloc();
    800054d2:	ffffb097          	auipc	ra,0xffffb
    800054d6:	c46080e7          	jalr	-954(ra) # 80000118 <kalloc>
    800054da:	00014497          	auipc	s1,0x14
    800054de:	7a648493          	addi	s1,s1,1958 # 80019c80 <disk>
    800054e2:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800054e4:	ffffb097          	auipc	ra,0xffffb
    800054e8:	c34080e7          	jalr	-972(ra) # 80000118 <kalloc>
    800054ec:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800054ee:	ffffb097          	auipc	ra,0xffffb
    800054f2:	c2a080e7          	jalr	-982(ra) # 80000118 <kalloc>
    800054f6:	87aa                	mv	a5,a0
    800054f8:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800054fa:	6088                	ld	a0,0(s1)
    800054fc:	cd75                	beqz	a0,800055f8 <virtio_disk_init+0x1e0>
    800054fe:	00014717          	auipc	a4,0x14
    80005502:	78a73703          	ld	a4,1930(a4) # 80019c88 <disk+0x8>
    80005506:	cb6d                	beqz	a4,800055f8 <virtio_disk_init+0x1e0>
    80005508:	cbe5                	beqz	a5,800055f8 <virtio_disk_init+0x1e0>
  memset(disk.desc, 0, PGSIZE);
    8000550a:	6605                	lui	a2,0x1
    8000550c:	4581                	li	a1,0
    8000550e:	ffffb097          	auipc	ra,0xffffb
    80005512:	c6a080e7          	jalr	-918(ra) # 80000178 <memset>
  memset(disk.avail, 0, PGSIZE);
    80005516:	00014497          	auipc	s1,0x14
    8000551a:	76a48493          	addi	s1,s1,1898 # 80019c80 <disk>
    8000551e:	6605                	lui	a2,0x1
    80005520:	4581                	li	a1,0
    80005522:	6488                	ld	a0,8(s1)
    80005524:	ffffb097          	auipc	ra,0xffffb
    80005528:	c54080e7          	jalr	-940(ra) # 80000178 <memset>
  memset(disk.used, 0, PGSIZE);
    8000552c:	6605                	lui	a2,0x1
    8000552e:	4581                	li	a1,0
    80005530:	6888                	ld	a0,16(s1)
    80005532:	ffffb097          	auipc	ra,0xffffb
    80005536:	c46080e7          	jalr	-954(ra) # 80000178 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000553a:	100017b7          	lui	a5,0x10001
    8000553e:	4721                	li	a4,8
    80005540:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005542:	4098                	lw	a4,0(s1)
    80005544:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005548:	40d8                	lw	a4,4(s1)
    8000554a:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000554e:	6498                	ld	a4,8(s1)
    80005550:	0007069b          	sext.w	a3,a4
    80005554:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005558:	9701                	srai	a4,a4,0x20
    8000555a:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    8000555e:	6898                	ld	a4,16(s1)
    80005560:	0007069b          	sext.w	a3,a4
    80005564:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005568:	9701                	srai	a4,a4,0x20
    8000556a:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    8000556e:	4685                	li	a3,1
    80005570:	c3f4                	sw	a3,68(a5)
    disk.free[i] = 1;
    80005572:	4705                	li	a4,1
    80005574:	00d48c23          	sb	a3,24(s1)
    80005578:	00e48ca3          	sb	a4,25(s1)
    8000557c:	00e48d23          	sb	a4,26(s1)
    80005580:	00e48da3          	sb	a4,27(s1)
    80005584:	00e48e23          	sb	a4,28(s1)
    80005588:	00e48ea3          	sb	a4,29(s1)
    8000558c:	00e48f23          	sb	a4,30(s1)
    80005590:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005594:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005598:	0727a823          	sw	s2,112(a5)
}
    8000559c:	60e2                	ld	ra,24(sp)
    8000559e:	6442                	ld	s0,16(sp)
    800055a0:	64a2                	ld	s1,8(sp)
    800055a2:	6902                	ld	s2,0(sp)
    800055a4:	6105                	addi	sp,sp,32
    800055a6:	8082                	ret
    panic("could not find virtio disk");
    800055a8:	00003517          	auipc	a0,0x3
    800055ac:	1f050513          	addi	a0,a0,496 # 80008798 <syscalls+0x368>
    800055b0:	00001097          	auipc	ra,0x1
    800055b4:	8c2080e7          	jalr	-1854(ra) # 80005e72 <panic>
    panic("virtio disk FEATURES_OK unset");
    800055b8:	00003517          	auipc	a0,0x3
    800055bc:	20050513          	addi	a0,a0,512 # 800087b8 <syscalls+0x388>
    800055c0:	00001097          	auipc	ra,0x1
    800055c4:	8b2080e7          	jalr	-1870(ra) # 80005e72 <panic>
    panic("virtio disk should not be ready");
    800055c8:	00003517          	auipc	a0,0x3
    800055cc:	21050513          	addi	a0,a0,528 # 800087d8 <syscalls+0x3a8>
    800055d0:	00001097          	auipc	ra,0x1
    800055d4:	8a2080e7          	jalr	-1886(ra) # 80005e72 <panic>
    panic("virtio disk has no queue 0");
    800055d8:	00003517          	auipc	a0,0x3
    800055dc:	22050513          	addi	a0,a0,544 # 800087f8 <syscalls+0x3c8>
    800055e0:	00001097          	auipc	ra,0x1
    800055e4:	892080e7          	jalr	-1902(ra) # 80005e72 <panic>
    panic("virtio disk max queue too short");
    800055e8:	00003517          	auipc	a0,0x3
    800055ec:	23050513          	addi	a0,a0,560 # 80008818 <syscalls+0x3e8>
    800055f0:	00001097          	auipc	ra,0x1
    800055f4:	882080e7          	jalr	-1918(ra) # 80005e72 <panic>
    panic("virtio disk kalloc");
    800055f8:	00003517          	auipc	a0,0x3
    800055fc:	24050513          	addi	a0,a0,576 # 80008838 <syscalls+0x408>
    80005600:	00001097          	auipc	ra,0x1
    80005604:	872080e7          	jalr	-1934(ra) # 80005e72 <panic>

0000000080005608 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005608:	7159                	addi	sp,sp,-112
    8000560a:	f486                	sd	ra,104(sp)
    8000560c:	f0a2                	sd	s0,96(sp)
    8000560e:	eca6                	sd	s1,88(sp)
    80005610:	e8ca                	sd	s2,80(sp)
    80005612:	e4ce                	sd	s3,72(sp)
    80005614:	e0d2                	sd	s4,64(sp)
    80005616:	fc56                	sd	s5,56(sp)
    80005618:	f85a                	sd	s6,48(sp)
    8000561a:	f45e                	sd	s7,40(sp)
    8000561c:	f062                	sd	s8,32(sp)
    8000561e:	ec66                	sd	s9,24(sp)
    80005620:	e86a                	sd	s10,16(sp)
    80005622:	1880                	addi	s0,sp,112
    80005624:	892a                	mv	s2,a0
    80005626:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005628:	00c52c83          	lw	s9,12(a0)
    8000562c:	001c9c9b          	slliw	s9,s9,0x1
    80005630:	1c82                	slli	s9,s9,0x20
    80005632:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005636:	00014517          	auipc	a0,0x14
    8000563a:	77250513          	addi	a0,a0,1906 # 80019da8 <disk+0x128>
    8000563e:	00001097          	auipc	ra,0x1
    80005642:	d7e080e7          	jalr	-642(ra) # 800063bc <acquire>
  for(int i = 0; i < 3; i++){
    80005646:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005648:	4ba1                	li	s7,8
      disk.free[i] = 0;
    8000564a:	00014b17          	auipc	s6,0x14
    8000564e:	636b0b13          	addi	s6,s6,1590 # 80019c80 <disk>
  for(int i = 0; i < 3; i++){
    80005652:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    80005654:	8a4e                	mv	s4,s3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005656:	00014c17          	auipc	s8,0x14
    8000565a:	752c0c13          	addi	s8,s8,1874 # 80019da8 <disk+0x128>
    8000565e:	a8b5                	j	800056da <virtio_disk_rw+0xd2>
      disk.free[i] = 0;
    80005660:	00fb06b3          	add	a3,s6,a5
    80005664:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    80005668:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    8000566a:	0207c563          	bltz	a5,80005694 <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    8000566e:	2485                	addiw	s1,s1,1
    80005670:	0711                	addi	a4,a4,4
    80005672:	1f548a63          	beq	s1,s5,80005866 <virtio_disk_rw+0x25e>
    idx[i] = alloc_desc();
    80005676:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    80005678:	00014697          	auipc	a3,0x14
    8000567c:	60868693          	addi	a3,a3,1544 # 80019c80 <disk>
    80005680:	87d2                	mv	a5,s4
    if(disk.free[i]){
    80005682:	0186c583          	lbu	a1,24(a3)
    80005686:	fde9                	bnez	a1,80005660 <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    80005688:	2785                	addiw	a5,a5,1
    8000568a:	0685                	addi	a3,a3,1
    8000568c:	ff779be3          	bne	a5,s7,80005682 <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    80005690:	57fd                	li	a5,-1
    80005692:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    80005694:	02905a63          	blez	s1,800056c8 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    80005698:	f9042503          	lw	a0,-112(s0)
    8000569c:	00000097          	auipc	ra,0x0
    800056a0:	cfa080e7          	jalr	-774(ra) # 80005396 <free_desc>
      for(int j = 0; j < i; j++)
    800056a4:	4785                	li	a5,1
    800056a6:	0297d163          	bge	a5,s1,800056c8 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    800056aa:	f9442503          	lw	a0,-108(s0)
    800056ae:	00000097          	auipc	ra,0x0
    800056b2:	ce8080e7          	jalr	-792(ra) # 80005396 <free_desc>
      for(int j = 0; j < i; j++)
    800056b6:	4789                	li	a5,2
    800056b8:	0097d863          	bge	a5,s1,800056c8 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    800056bc:	f9842503          	lw	a0,-104(s0)
    800056c0:	00000097          	auipc	ra,0x0
    800056c4:	cd6080e7          	jalr	-810(ra) # 80005396 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    800056c8:	85e2                	mv	a1,s8
    800056ca:	00014517          	auipc	a0,0x14
    800056ce:	5ce50513          	addi	a0,a0,1486 # 80019c98 <disk+0x18>
    800056d2:	ffffc097          	auipc	ra,0xffffc
    800056d6:	fda080e7          	jalr	-38(ra) # 800016ac <sleep>
  for(int i = 0; i < 3; i++){
    800056da:	f9040713          	addi	a4,s0,-112
    800056de:	84ce                	mv	s1,s3
    800056e0:	bf59                	j	80005676 <virtio_disk_rw+0x6e>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    800056e2:	00a60793          	addi	a5,a2,10 # 100a <_entry-0x7fffeff6>
    800056e6:	00479693          	slli	a3,a5,0x4
    800056ea:	00014797          	auipc	a5,0x14
    800056ee:	59678793          	addi	a5,a5,1430 # 80019c80 <disk>
    800056f2:	97b6                	add	a5,a5,a3
    800056f4:	4685                	li	a3,1
    800056f6:	c794                	sw	a3,8(a5)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800056f8:	00014597          	auipc	a1,0x14
    800056fc:	58858593          	addi	a1,a1,1416 # 80019c80 <disk>
    80005700:	00a60793          	addi	a5,a2,10
    80005704:	0792                	slli	a5,a5,0x4
    80005706:	97ae                	add	a5,a5,a1
    80005708:	0007a623          	sw	zero,12(a5)
  buf0->sector = sector;
    8000570c:	0197b823          	sd	s9,16(a5)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005710:	f6070693          	addi	a3,a4,-160
    80005714:	619c                	ld	a5,0(a1)
    80005716:	97b6                	add	a5,a5,a3
    80005718:	e388                	sd	a0,0(a5)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000571a:	6188                	ld	a0,0(a1)
    8000571c:	96aa                	add	a3,a3,a0
    8000571e:	47c1                	li	a5,16
    80005720:	c69c                	sw	a5,8(a3)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005722:	4785                	li	a5,1
    80005724:	00f69623          	sh	a5,12(a3)
  disk.desc[idx[0]].next = idx[1];
    80005728:	f9442783          	lw	a5,-108(s0)
    8000572c:	00f69723          	sh	a5,14(a3)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005730:	0792                	slli	a5,a5,0x4
    80005732:	953e                	add	a0,a0,a5
    80005734:	05890693          	addi	a3,s2,88
    80005738:	e114                	sd	a3,0(a0)
  disk.desc[idx[1]].len = BSIZE;
    8000573a:	6188                	ld	a0,0(a1)
    8000573c:	97aa                	add	a5,a5,a0
    8000573e:	40000693          	li	a3,1024
    80005742:	c794                	sw	a3,8(a5)
  if(write)
    80005744:	100d0d63          	beqz	s10,8000585e <virtio_disk_rw+0x256>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80005748:	00079623          	sh	zero,12(a5)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000574c:	00c7d683          	lhu	a3,12(a5)
    80005750:	0016e693          	ori	a3,a3,1
    80005754:	00d79623          	sh	a3,12(a5)
  disk.desc[idx[1]].next = idx[2];
    80005758:	f9842583          	lw	a1,-104(s0)
    8000575c:	00b79723          	sh	a1,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005760:	00014697          	auipc	a3,0x14
    80005764:	52068693          	addi	a3,a3,1312 # 80019c80 <disk>
    80005768:	00260793          	addi	a5,a2,2
    8000576c:	0792                	slli	a5,a5,0x4
    8000576e:	97b6                	add	a5,a5,a3
    80005770:	587d                	li	a6,-1
    80005772:	01078823          	sb	a6,16(a5)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005776:	0592                	slli	a1,a1,0x4
    80005778:	952e                	add	a0,a0,a1
    8000577a:	f9070713          	addi	a4,a4,-112
    8000577e:	9736                	add	a4,a4,a3
    80005780:	e118                	sd	a4,0(a0)
  disk.desc[idx[2]].len = 1;
    80005782:	6298                	ld	a4,0(a3)
    80005784:	972e                	add	a4,a4,a1
    80005786:	4585                	li	a1,1
    80005788:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000578a:	4509                	li	a0,2
    8000578c:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[2]].next = 0;
    80005790:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005794:	00b92223          	sw	a1,4(s2)
  disk.info[idx[0]].b = b;
    80005798:	0127b423          	sd	s2,8(a5)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    8000579c:	6698                	ld	a4,8(a3)
    8000579e:	00275783          	lhu	a5,2(a4)
    800057a2:	8b9d                	andi	a5,a5,7
    800057a4:	0786                	slli	a5,a5,0x1
    800057a6:	97ba                	add	a5,a5,a4
    800057a8:	00c79223          	sh	a2,4(a5)

  __sync_synchronize();
    800057ac:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800057b0:	6698                	ld	a4,8(a3)
    800057b2:	00275783          	lhu	a5,2(a4)
    800057b6:	2785                	addiw	a5,a5,1
    800057b8:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800057bc:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800057c0:	100017b7          	lui	a5,0x10001
    800057c4:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800057c8:	00492703          	lw	a4,4(s2)
    800057cc:	4785                	li	a5,1
    800057ce:	02f71163          	bne	a4,a5,800057f0 <virtio_disk_rw+0x1e8>
    sleep(b, &disk.vdisk_lock);
    800057d2:	00014997          	auipc	s3,0x14
    800057d6:	5d698993          	addi	s3,s3,1494 # 80019da8 <disk+0x128>
  while(b->disk == 1) {
    800057da:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800057dc:	85ce                	mv	a1,s3
    800057de:	854a                	mv	a0,s2
    800057e0:	ffffc097          	auipc	ra,0xffffc
    800057e4:	ecc080e7          	jalr	-308(ra) # 800016ac <sleep>
  while(b->disk == 1) {
    800057e8:	00492783          	lw	a5,4(s2)
    800057ec:	fe9788e3          	beq	a5,s1,800057dc <virtio_disk_rw+0x1d4>
  }

  disk.info[idx[0]].b = 0;
    800057f0:	f9042903          	lw	s2,-112(s0)
    800057f4:	00290793          	addi	a5,s2,2
    800057f8:	00479713          	slli	a4,a5,0x4
    800057fc:	00014797          	auipc	a5,0x14
    80005800:	48478793          	addi	a5,a5,1156 # 80019c80 <disk>
    80005804:	97ba                	add	a5,a5,a4
    80005806:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    8000580a:	00014997          	auipc	s3,0x14
    8000580e:	47698993          	addi	s3,s3,1142 # 80019c80 <disk>
    80005812:	00491713          	slli	a4,s2,0x4
    80005816:	0009b783          	ld	a5,0(s3)
    8000581a:	97ba                	add	a5,a5,a4
    8000581c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005820:	854a                	mv	a0,s2
    80005822:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005826:	00000097          	auipc	ra,0x0
    8000582a:	b70080e7          	jalr	-1168(ra) # 80005396 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000582e:	8885                	andi	s1,s1,1
    80005830:	f0ed                	bnez	s1,80005812 <virtio_disk_rw+0x20a>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005832:	00014517          	auipc	a0,0x14
    80005836:	57650513          	addi	a0,a0,1398 # 80019da8 <disk+0x128>
    8000583a:	00001097          	auipc	ra,0x1
    8000583e:	c36080e7          	jalr	-970(ra) # 80006470 <release>
}
    80005842:	70a6                	ld	ra,104(sp)
    80005844:	7406                	ld	s0,96(sp)
    80005846:	64e6                	ld	s1,88(sp)
    80005848:	6946                	ld	s2,80(sp)
    8000584a:	69a6                	ld	s3,72(sp)
    8000584c:	6a06                	ld	s4,64(sp)
    8000584e:	7ae2                	ld	s5,56(sp)
    80005850:	7b42                	ld	s6,48(sp)
    80005852:	7ba2                	ld	s7,40(sp)
    80005854:	7c02                	ld	s8,32(sp)
    80005856:	6ce2                	ld	s9,24(sp)
    80005858:	6d42                	ld	s10,16(sp)
    8000585a:	6165                	addi	sp,sp,112
    8000585c:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000585e:	4689                	li	a3,2
    80005860:	00d79623          	sh	a3,12(a5)
    80005864:	b5e5                	j	8000574c <virtio_disk_rw+0x144>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005866:	f9042603          	lw	a2,-112(s0)
    8000586a:	00a60713          	addi	a4,a2,10
    8000586e:	0712                	slli	a4,a4,0x4
    80005870:	00014517          	auipc	a0,0x14
    80005874:	41850513          	addi	a0,a0,1048 # 80019c88 <disk+0x8>
    80005878:	953a                	add	a0,a0,a4
  if(write)
    8000587a:	e60d14e3          	bnez	s10,800056e2 <virtio_disk_rw+0xda>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    8000587e:	00a60793          	addi	a5,a2,10
    80005882:	00479693          	slli	a3,a5,0x4
    80005886:	00014797          	auipc	a5,0x14
    8000588a:	3fa78793          	addi	a5,a5,1018 # 80019c80 <disk>
    8000588e:	97b6                	add	a5,a5,a3
    80005890:	0007a423          	sw	zero,8(a5)
    80005894:	b595                	j	800056f8 <virtio_disk_rw+0xf0>

0000000080005896 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005896:	1101                	addi	sp,sp,-32
    80005898:	ec06                	sd	ra,24(sp)
    8000589a:	e822                	sd	s0,16(sp)
    8000589c:	e426                	sd	s1,8(sp)
    8000589e:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800058a0:	00014497          	auipc	s1,0x14
    800058a4:	3e048493          	addi	s1,s1,992 # 80019c80 <disk>
    800058a8:	00014517          	auipc	a0,0x14
    800058ac:	50050513          	addi	a0,a0,1280 # 80019da8 <disk+0x128>
    800058b0:	00001097          	auipc	ra,0x1
    800058b4:	b0c080e7          	jalr	-1268(ra) # 800063bc <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800058b8:	10001737          	lui	a4,0x10001
    800058bc:	533c                	lw	a5,96(a4)
    800058be:	8b8d                	andi	a5,a5,3
    800058c0:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800058c2:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800058c6:	689c                	ld	a5,16(s1)
    800058c8:	0204d703          	lhu	a4,32(s1)
    800058cc:	0027d783          	lhu	a5,2(a5)
    800058d0:	04f70863          	beq	a4,a5,80005920 <virtio_disk_intr+0x8a>
    __sync_synchronize();
    800058d4:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800058d8:	6898                	ld	a4,16(s1)
    800058da:	0204d783          	lhu	a5,32(s1)
    800058de:	8b9d                	andi	a5,a5,7
    800058e0:	078e                	slli	a5,a5,0x3
    800058e2:	97ba                	add	a5,a5,a4
    800058e4:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800058e6:	00278713          	addi	a4,a5,2
    800058ea:	0712                	slli	a4,a4,0x4
    800058ec:	9726                	add	a4,a4,s1
    800058ee:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    800058f2:	e721                	bnez	a4,8000593a <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800058f4:	0789                	addi	a5,a5,2
    800058f6:	0792                	slli	a5,a5,0x4
    800058f8:	97a6                	add	a5,a5,s1
    800058fa:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    800058fc:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005900:	ffffc097          	auipc	ra,0xffffc
    80005904:	e10080e7          	jalr	-496(ra) # 80001710 <wakeup>

    disk.used_idx += 1;
    80005908:	0204d783          	lhu	a5,32(s1)
    8000590c:	2785                	addiw	a5,a5,1
    8000590e:	17c2                	slli	a5,a5,0x30
    80005910:	93c1                	srli	a5,a5,0x30
    80005912:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005916:	6898                	ld	a4,16(s1)
    80005918:	00275703          	lhu	a4,2(a4)
    8000591c:	faf71ce3          	bne	a4,a5,800058d4 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005920:	00014517          	auipc	a0,0x14
    80005924:	48850513          	addi	a0,a0,1160 # 80019da8 <disk+0x128>
    80005928:	00001097          	auipc	ra,0x1
    8000592c:	b48080e7          	jalr	-1208(ra) # 80006470 <release>
}
    80005930:	60e2                	ld	ra,24(sp)
    80005932:	6442                	ld	s0,16(sp)
    80005934:	64a2                	ld	s1,8(sp)
    80005936:	6105                	addi	sp,sp,32
    80005938:	8082                	ret
      panic("virtio_disk_intr status");
    8000593a:	00003517          	auipc	a0,0x3
    8000593e:	f1650513          	addi	a0,a0,-234 # 80008850 <syscalls+0x420>
    80005942:	00000097          	auipc	ra,0x0
    80005946:	530080e7          	jalr	1328(ra) # 80005e72 <panic>

000000008000594a <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000594a:	1141                	addi	sp,sp,-16
    8000594c:	e422                	sd	s0,8(sp)
    8000594e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005950:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005954:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005958:	0037979b          	slliw	a5,a5,0x3
    8000595c:	02004737          	lui	a4,0x2004
    80005960:	97ba                	add	a5,a5,a4
    80005962:	0200c737          	lui	a4,0x200c
    80005966:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    8000596a:	000f4637          	lui	a2,0xf4
    8000596e:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005972:	95b2                	add	a1,a1,a2
    80005974:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005976:	00269713          	slli	a4,a3,0x2
    8000597a:	9736                	add	a4,a4,a3
    8000597c:	00371693          	slli	a3,a4,0x3
    80005980:	00014717          	auipc	a4,0x14
    80005984:	44070713          	addi	a4,a4,1088 # 80019dc0 <timer_scratch>
    80005988:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000598a:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000598c:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000598e:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005992:	00000797          	auipc	a5,0x0
    80005996:	93e78793          	addi	a5,a5,-1730 # 800052d0 <timervec>
    8000599a:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000599e:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    800059a2:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800059a6:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    800059aa:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    800059ae:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    800059b2:	30479073          	csrw	mie,a5
}
    800059b6:	6422                	ld	s0,8(sp)
    800059b8:	0141                	addi	sp,sp,16
    800059ba:	8082                	ret

00000000800059bc <start>:
{
    800059bc:	1141                	addi	sp,sp,-16
    800059be:	e406                	sd	ra,8(sp)
    800059c0:	e022                	sd	s0,0(sp)
    800059c2:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800059c4:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800059c8:	7779                	lui	a4,0xffffe
    800059ca:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdc7ff>
    800059ce:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800059d0:	6705                	lui	a4,0x1
    800059d2:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800059d6:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800059d8:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800059dc:	ffffb797          	auipc	a5,0xffffb
    800059e0:	94a78793          	addi	a5,a5,-1718 # 80000326 <main>
    800059e4:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800059e8:	4781                	li	a5,0
    800059ea:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800059ee:	67c1                	lui	a5,0x10
    800059f0:	17fd                	addi	a5,a5,-1
    800059f2:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800059f6:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800059fa:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800059fe:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005a02:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005a06:	57fd                	li	a5,-1
    80005a08:	83a9                	srli	a5,a5,0xa
    80005a0a:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005a0e:	47bd                	li	a5,15
    80005a10:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005a14:	00000097          	auipc	ra,0x0
    80005a18:	f36080e7          	jalr	-202(ra) # 8000594a <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005a1c:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005a20:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005a22:	823e                	mv	tp,a5
  asm volatile("mret");
    80005a24:	30200073          	mret
}
    80005a28:	60a2                	ld	ra,8(sp)
    80005a2a:	6402                	ld	s0,0(sp)
    80005a2c:	0141                	addi	sp,sp,16
    80005a2e:	8082                	ret

0000000080005a30 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005a30:	715d                	addi	sp,sp,-80
    80005a32:	e486                	sd	ra,72(sp)
    80005a34:	e0a2                	sd	s0,64(sp)
    80005a36:	fc26                	sd	s1,56(sp)
    80005a38:	f84a                	sd	s2,48(sp)
    80005a3a:	f44e                	sd	s3,40(sp)
    80005a3c:	f052                	sd	s4,32(sp)
    80005a3e:	ec56                	sd	s5,24(sp)
    80005a40:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005a42:	04c05663          	blez	a2,80005a8e <consolewrite+0x5e>
    80005a46:	8a2a                	mv	s4,a0
    80005a48:	84ae                	mv	s1,a1
    80005a4a:	89b2                	mv	s3,a2
    80005a4c:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005a4e:	5afd                	li	s5,-1
    80005a50:	4685                	li	a3,1
    80005a52:	8626                	mv	a2,s1
    80005a54:	85d2                	mv	a1,s4
    80005a56:	fbf40513          	addi	a0,s0,-65
    80005a5a:	ffffc097          	auipc	ra,0xffffc
    80005a5e:	0b0080e7          	jalr	176(ra) # 80001b0a <either_copyin>
    80005a62:	01550c63          	beq	a0,s5,80005a7a <consolewrite+0x4a>
      break;
    uartputc(c);
    80005a66:	fbf44503          	lbu	a0,-65(s0)
    80005a6a:	00000097          	auipc	ra,0x0
    80005a6e:	794080e7          	jalr	1940(ra) # 800061fe <uartputc>
  for(i = 0; i < n; i++){
    80005a72:	2905                	addiw	s2,s2,1
    80005a74:	0485                	addi	s1,s1,1
    80005a76:	fd299de3          	bne	s3,s2,80005a50 <consolewrite+0x20>
  }

  return i;
}
    80005a7a:	854a                	mv	a0,s2
    80005a7c:	60a6                	ld	ra,72(sp)
    80005a7e:	6406                	ld	s0,64(sp)
    80005a80:	74e2                	ld	s1,56(sp)
    80005a82:	7942                	ld	s2,48(sp)
    80005a84:	79a2                	ld	s3,40(sp)
    80005a86:	7a02                	ld	s4,32(sp)
    80005a88:	6ae2                	ld	s5,24(sp)
    80005a8a:	6161                	addi	sp,sp,80
    80005a8c:	8082                	ret
  for(i = 0; i < n; i++){
    80005a8e:	4901                	li	s2,0
    80005a90:	b7ed                	j	80005a7a <consolewrite+0x4a>

0000000080005a92 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005a92:	7119                	addi	sp,sp,-128
    80005a94:	fc86                	sd	ra,120(sp)
    80005a96:	f8a2                	sd	s0,112(sp)
    80005a98:	f4a6                	sd	s1,104(sp)
    80005a9a:	f0ca                	sd	s2,96(sp)
    80005a9c:	ecce                	sd	s3,88(sp)
    80005a9e:	e8d2                	sd	s4,80(sp)
    80005aa0:	e4d6                	sd	s5,72(sp)
    80005aa2:	e0da                	sd	s6,64(sp)
    80005aa4:	fc5e                	sd	s7,56(sp)
    80005aa6:	f862                	sd	s8,48(sp)
    80005aa8:	f466                	sd	s9,40(sp)
    80005aaa:	f06a                	sd	s10,32(sp)
    80005aac:	ec6e                	sd	s11,24(sp)
    80005aae:	0100                	addi	s0,sp,128
    80005ab0:	8b2a                	mv	s6,a0
    80005ab2:	8aae                	mv	s5,a1
    80005ab4:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005ab6:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    80005aba:	0001c517          	auipc	a0,0x1c
    80005abe:	44650513          	addi	a0,a0,1094 # 80021f00 <cons>
    80005ac2:	00001097          	auipc	ra,0x1
    80005ac6:	8fa080e7          	jalr	-1798(ra) # 800063bc <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005aca:	0001c497          	auipc	s1,0x1c
    80005ace:	43648493          	addi	s1,s1,1078 # 80021f00 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005ad2:	89a6                	mv	s3,s1
    80005ad4:	0001c917          	auipc	s2,0x1c
    80005ad8:	4c490913          	addi	s2,s2,1220 # 80021f98 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    80005adc:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005ade:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005ae0:	4da9                	li	s11,10
  while(n > 0){
    80005ae2:	07405b63          	blez	s4,80005b58 <consoleread+0xc6>
    while(cons.r == cons.w){
    80005ae6:	0984a783          	lw	a5,152(s1)
    80005aea:	09c4a703          	lw	a4,156(s1)
    80005aee:	02f71763          	bne	a4,a5,80005b1c <consoleread+0x8a>
      if(killed(myproc())){
    80005af2:	ffffb097          	auipc	ra,0xffffb
    80005af6:	44e080e7          	jalr	1102(ra) # 80000f40 <myproc>
    80005afa:	ffffc097          	auipc	ra,0xffffc
    80005afe:	e5a080e7          	jalr	-422(ra) # 80001954 <killed>
    80005b02:	e535                	bnez	a0,80005b6e <consoleread+0xdc>
      sleep(&cons.r, &cons.lock);
    80005b04:	85ce                	mv	a1,s3
    80005b06:	854a                	mv	a0,s2
    80005b08:	ffffc097          	auipc	ra,0xffffc
    80005b0c:	ba4080e7          	jalr	-1116(ra) # 800016ac <sleep>
    while(cons.r == cons.w){
    80005b10:	0984a783          	lw	a5,152(s1)
    80005b14:	09c4a703          	lw	a4,156(s1)
    80005b18:	fcf70de3          	beq	a4,a5,80005af2 <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005b1c:	0017871b          	addiw	a4,a5,1
    80005b20:	08e4ac23          	sw	a4,152(s1)
    80005b24:	07f7f713          	andi	a4,a5,127
    80005b28:	9726                	add	a4,a4,s1
    80005b2a:	01874703          	lbu	a4,24(a4)
    80005b2e:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005b32:	079c0663          	beq	s8,s9,80005b9e <consoleread+0x10c>
    cbuf = c;
    80005b36:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005b3a:	4685                	li	a3,1
    80005b3c:	f8f40613          	addi	a2,s0,-113
    80005b40:	85d6                	mv	a1,s5
    80005b42:	855a                	mv	a0,s6
    80005b44:	ffffc097          	auipc	ra,0xffffc
    80005b48:	f70080e7          	jalr	-144(ra) # 80001ab4 <either_copyout>
    80005b4c:	01a50663          	beq	a0,s10,80005b58 <consoleread+0xc6>
    dst++;
    80005b50:	0a85                	addi	s5,s5,1
    --n;
    80005b52:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    80005b54:	f9bc17e3          	bne	s8,s11,80005ae2 <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005b58:	0001c517          	auipc	a0,0x1c
    80005b5c:	3a850513          	addi	a0,a0,936 # 80021f00 <cons>
    80005b60:	00001097          	auipc	ra,0x1
    80005b64:	910080e7          	jalr	-1776(ra) # 80006470 <release>

  return target - n;
    80005b68:	414b853b          	subw	a0,s7,s4
    80005b6c:	a811                	j	80005b80 <consoleread+0xee>
        release(&cons.lock);
    80005b6e:	0001c517          	auipc	a0,0x1c
    80005b72:	39250513          	addi	a0,a0,914 # 80021f00 <cons>
    80005b76:	00001097          	auipc	ra,0x1
    80005b7a:	8fa080e7          	jalr	-1798(ra) # 80006470 <release>
        return -1;
    80005b7e:	557d                	li	a0,-1
}
    80005b80:	70e6                	ld	ra,120(sp)
    80005b82:	7446                	ld	s0,112(sp)
    80005b84:	74a6                	ld	s1,104(sp)
    80005b86:	7906                	ld	s2,96(sp)
    80005b88:	69e6                	ld	s3,88(sp)
    80005b8a:	6a46                	ld	s4,80(sp)
    80005b8c:	6aa6                	ld	s5,72(sp)
    80005b8e:	6b06                	ld	s6,64(sp)
    80005b90:	7be2                	ld	s7,56(sp)
    80005b92:	7c42                	ld	s8,48(sp)
    80005b94:	7ca2                	ld	s9,40(sp)
    80005b96:	7d02                	ld	s10,32(sp)
    80005b98:	6de2                	ld	s11,24(sp)
    80005b9a:	6109                	addi	sp,sp,128
    80005b9c:	8082                	ret
      if(n < target){
    80005b9e:	000a071b          	sext.w	a4,s4
    80005ba2:	fb777be3          	bgeu	a4,s7,80005b58 <consoleread+0xc6>
        cons.r--;
    80005ba6:	0001c717          	auipc	a4,0x1c
    80005baa:	3ef72923          	sw	a5,1010(a4) # 80021f98 <cons+0x98>
    80005bae:	b76d                	j	80005b58 <consoleread+0xc6>

0000000080005bb0 <consputc>:
{
    80005bb0:	1141                	addi	sp,sp,-16
    80005bb2:	e406                	sd	ra,8(sp)
    80005bb4:	e022                	sd	s0,0(sp)
    80005bb6:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005bb8:	10000793          	li	a5,256
    80005bbc:	00f50a63          	beq	a0,a5,80005bd0 <consputc+0x20>
    uartputc_sync(c);
    80005bc0:	00000097          	auipc	ra,0x0
    80005bc4:	564080e7          	jalr	1380(ra) # 80006124 <uartputc_sync>
}
    80005bc8:	60a2                	ld	ra,8(sp)
    80005bca:	6402                	ld	s0,0(sp)
    80005bcc:	0141                	addi	sp,sp,16
    80005bce:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005bd0:	4521                	li	a0,8
    80005bd2:	00000097          	auipc	ra,0x0
    80005bd6:	552080e7          	jalr	1362(ra) # 80006124 <uartputc_sync>
    80005bda:	02000513          	li	a0,32
    80005bde:	00000097          	auipc	ra,0x0
    80005be2:	546080e7          	jalr	1350(ra) # 80006124 <uartputc_sync>
    80005be6:	4521                	li	a0,8
    80005be8:	00000097          	auipc	ra,0x0
    80005bec:	53c080e7          	jalr	1340(ra) # 80006124 <uartputc_sync>
    80005bf0:	bfe1                	j	80005bc8 <consputc+0x18>

0000000080005bf2 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005bf2:	1101                	addi	sp,sp,-32
    80005bf4:	ec06                	sd	ra,24(sp)
    80005bf6:	e822                	sd	s0,16(sp)
    80005bf8:	e426                	sd	s1,8(sp)
    80005bfa:	e04a                	sd	s2,0(sp)
    80005bfc:	1000                	addi	s0,sp,32
    80005bfe:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005c00:	0001c517          	auipc	a0,0x1c
    80005c04:	30050513          	addi	a0,a0,768 # 80021f00 <cons>
    80005c08:	00000097          	auipc	ra,0x0
    80005c0c:	7b4080e7          	jalr	1972(ra) # 800063bc <acquire>

  switch(c){
    80005c10:	47d5                	li	a5,21
    80005c12:	0af48663          	beq	s1,a5,80005cbe <consoleintr+0xcc>
    80005c16:	0297ca63          	blt	a5,s1,80005c4a <consoleintr+0x58>
    80005c1a:	47a1                	li	a5,8
    80005c1c:	0ef48763          	beq	s1,a5,80005d0a <consoleintr+0x118>
    80005c20:	47c1                	li	a5,16
    80005c22:	10f49a63          	bne	s1,a5,80005d36 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005c26:	ffffc097          	auipc	ra,0xffffc
    80005c2a:	f3a080e7          	jalr	-198(ra) # 80001b60 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005c2e:	0001c517          	auipc	a0,0x1c
    80005c32:	2d250513          	addi	a0,a0,722 # 80021f00 <cons>
    80005c36:	00001097          	auipc	ra,0x1
    80005c3a:	83a080e7          	jalr	-1990(ra) # 80006470 <release>
}
    80005c3e:	60e2                	ld	ra,24(sp)
    80005c40:	6442                	ld	s0,16(sp)
    80005c42:	64a2                	ld	s1,8(sp)
    80005c44:	6902                	ld	s2,0(sp)
    80005c46:	6105                	addi	sp,sp,32
    80005c48:	8082                	ret
  switch(c){
    80005c4a:	07f00793          	li	a5,127
    80005c4e:	0af48e63          	beq	s1,a5,80005d0a <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005c52:	0001c717          	auipc	a4,0x1c
    80005c56:	2ae70713          	addi	a4,a4,686 # 80021f00 <cons>
    80005c5a:	0a072783          	lw	a5,160(a4)
    80005c5e:	09872703          	lw	a4,152(a4)
    80005c62:	9f99                	subw	a5,a5,a4
    80005c64:	07f00713          	li	a4,127
    80005c68:	fcf763e3          	bltu	a4,a5,80005c2e <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005c6c:	47b5                	li	a5,13
    80005c6e:	0cf48763          	beq	s1,a5,80005d3c <consoleintr+0x14a>
      consputc(c);
    80005c72:	8526                	mv	a0,s1
    80005c74:	00000097          	auipc	ra,0x0
    80005c78:	f3c080e7          	jalr	-196(ra) # 80005bb0 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005c7c:	0001c797          	auipc	a5,0x1c
    80005c80:	28478793          	addi	a5,a5,644 # 80021f00 <cons>
    80005c84:	0a07a683          	lw	a3,160(a5)
    80005c88:	0016871b          	addiw	a4,a3,1
    80005c8c:	0007061b          	sext.w	a2,a4
    80005c90:	0ae7a023          	sw	a4,160(a5)
    80005c94:	07f6f693          	andi	a3,a3,127
    80005c98:	97b6                	add	a5,a5,a3
    80005c9a:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005c9e:	47a9                	li	a5,10
    80005ca0:	0cf48563          	beq	s1,a5,80005d6a <consoleintr+0x178>
    80005ca4:	4791                	li	a5,4
    80005ca6:	0cf48263          	beq	s1,a5,80005d6a <consoleintr+0x178>
    80005caa:	0001c797          	auipc	a5,0x1c
    80005cae:	2ee7a783          	lw	a5,750(a5) # 80021f98 <cons+0x98>
    80005cb2:	9f1d                	subw	a4,a4,a5
    80005cb4:	08000793          	li	a5,128
    80005cb8:	f6f71be3          	bne	a4,a5,80005c2e <consoleintr+0x3c>
    80005cbc:	a07d                	j	80005d6a <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005cbe:	0001c717          	auipc	a4,0x1c
    80005cc2:	24270713          	addi	a4,a4,578 # 80021f00 <cons>
    80005cc6:	0a072783          	lw	a5,160(a4)
    80005cca:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005cce:	0001c497          	auipc	s1,0x1c
    80005cd2:	23248493          	addi	s1,s1,562 # 80021f00 <cons>
    while(cons.e != cons.w &&
    80005cd6:	4929                	li	s2,10
    80005cd8:	f4f70be3          	beq	a4,a5,80005c2e <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005cdc:	37fd                	addiw	a5,a5,-1
    80005cde:	07f7f713          	andi	a4,a5,127
    80005ce2:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005ce4:	01874703          	lbu	a4,24(a4)
    80005ce8:	f52703e3          	beq	a4,s2,80005c2e <consoleintr+0x3c>
      cons.e--;
    80005cec:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005cf0:	10000513          	li	a0,256
    80005cf4:	00000097          	auipc	ra,0x0
    80005cf8:	ebc080e7          	jalr	-324(ra) # 80005bb0 <consputc>
    while(cons.e != cons.w &&
    80005cfc:	0a04a783          	lw	a5,160(s1)
    80005d00:	09c4a703          	lw	a4,156(s1)
    80005d04:	fcf71ce3          	bne	a4,a5,80005cdc <consoleintr+0xea>
    80005d08:	b71d                	j	80005c2e <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005d0a:	0001c717          	auipc	a4,0x1c
    80005d0e:	1f670713          	addi	a4,a4,502 # 80021f00 <cons>
    80005d12:	0a072783          	lw	a5,160(a4)
    80005d16:	09c72703          	lw	a4,156(a4)
    80005d1a:	f0f70ae3          	beq	a4,a5,80005c2e <consoleintr+0x3c>
      cons.e--;
    80005d1e:	37fd                	addiw	a5,a5,-1
    80005d20:	0001c717          	auipc	a4,0x1c
    80005d24:	28f72023          	sw	a5,640(a4) # 80021fa0 <cons+0xa0>
      consputc(BACKSPACE);
    80005d28:	10000513          	li	a0,256
    80005d2c:	00000097          	auipc	ra,0x0
    80005d30:	e84080e7          	jalr	-380(ra) # 80005bb0 <consputc>
    80005d34:	bded                	j	80005c2e <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005d36:	ee048ce3          	beqz	s1,80005c2e <consoleintr+0x3c>
    80005d3a:	bf21                	j	80005c52 <consoleintr+0x60>
      consputc(c);
    80005d3c:	4529                	li	a0,10
    80005d3e:	00000097          	auipc	ra,0x0
    80005d42:	e72080e7          	jalr	-398(ra) # 80005bb0 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005d46:	0001c797          	auipc	a5,0x1c
    80005d4a:	1ba78793          	addi	a5,a5,442 # 80021f00 <cons>
    80005d4e:	0a07a703          	lw	a4,160(a5)
    80005d52:	0017069b          	addiw	a3,a4,1
    80005d56:	0006861b          	sext.w	a2,a3
    80005d5a:	0ad7a023          	sw	a3,160(a5)
    80005d5e:	07f77713          	andi	a4,a4,127
    80005d62:	97ba                	add	a5,a5,a4
    80005d64:	4729                	li	a4,10
    80005d66:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005d6a:	0001c797          	auipc	a5,0x1c
    80005d6e:	22c7a923          	sw	a2,562(a5) # 80021f9c <cons+0x9c>
        wakeup(&cons.r);
    80005d72:	0001c517          	auipc	a0,0x1c
    80005d76:	22650513          	addi	a0,a0,550 # 80021f98 <cons+0x98>
    80005d7a:	ffffc097          	auipc	ra,0xffffc
    80005d7e:	996080e7          	jalr	-1642(ra) # 80001710 <wakeup>
    80005d82:	b575                	j	80005c2e <consoleintr+0x3c>

0000000080005d84 <consoleinit>:

void
consoleinit(void)
{
    80005d84:	1141                	addi	sp,sp,-16
    80005d86:	e406                	sd	ra,8(sp)
    80005d88:	e022                	sd	s0,0(sp)
    80005d8a:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005d8c:	00003597          	auipc	a1,0x3
    80005d90:	adc58593          	addi	a1,a1,-1316 # 80008868 <syscalls+0x438>
    80005d94:	0001c517          	auipc	a0,0x1c
    80005d98:	16c50513          	addi	a0,a0,364 # 80021f00 <cons>
    80005d9c:	00000097          	auipc	ra,0x0
    80005da0:	590080e7          	jalr	1424(ra) # 8000632c <initlock>

  uartinit();
    80005da4:	00000097          	auipc	ra,0x0
    80005da8:	330080e7          	jalr	816(ra) # 800060d4 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005dac:	00013797          	auipc	a5,0x13
    80005db0:	e7c78793          	addi	a5,a5,-388 # 80018c28 <devsw>
    80005db4:	00000717          	auipc	a4,0x0
    80005db8:	cde70713          	addi	a4,a4,-802 # 80005a92 <consoleread>
    80005dbc:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005dbe:	00000717          	auipc	a4,0x0
    80005dc2:	c7270713          	addi	a4,a4,-910 # 80005a30 <consolewrite>
    80005dc6:	ef98                	sd	a4,24(a5)
}
    80005dc8:	60a2                	ld	ra,8(sp)
    80005dca:	6402                	ld	s0,0(sp)
    80005dcc:	0141                	addi	sp,sp,16
    80005dce:	8082                	ret

0000000080005dd0 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005dd0:	7179                	addi	sp,sp,-48
    80005dd2:	f406                	sd	ra,40(sp)
    80005dd4:	f022                	sd	s0,32(sp)
    80005dd6:	ec26                	sd	s1,24(sp)
    80005dd8:	e84a                	sd	s2,16(sp)
    80005dda:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005ddc:	c219                	beqz	a2,80005de2 <printint+0x12>
    80005dde:	08054663          	bltz	a0,80005e6a <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005de2:	2501                	sext.w	a0,a0
    80005de4:	4881                	li	a7,0
    80005de6:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005dea:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005dec:	2581                	sext.w	a1,a1
    80005dee:	00003617          	auipc	a2,0x3
    80005df2:	aaa60613          	addi	a2,a2,-1366 # 80008898 <digits>
    80005df6:	883a                	mv	a6,a4
    80005df8:	2705                	addiw	a4,a4,1
    80005dfa:	02b577bb          	remuw	a5,a0,a1
    80005dfe:	1782                	slli	a5,a5,0x20
    80005e00:	9381                	srli	a5,a5,0x20
    80005e02:	97b2                	add	a5,a5,a2
    80005e04:	0007c783          	lbu	a5,0(a5)
    80005e08:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005e0c:	0005079b          	sext.w	a5,a0
    80005e10:	02b5553b          	divuw	a0,a0,a1
    80005e14:	0685                	addi	a3,a3,1
    80005e16:	feb7f0e3          	bgeu	a5,a1,80005df6 <printint+0x26>

  if(sign)
    80005e1a:	00088b63          	beqz	a7,80005e30 <printint+0x60>
    buf[i++] = '-';
    80005e1e:	fe040793          	addi	a5,s0,-32
    80005e22:	973e                	add	a4,a4,a5
    80005e24:	02d00793          	li	a5,45
    80005e28:	fef70823          	sb	a5,-16(a4)
    80005e2c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005e30:	02e05763          	blez	a4,80005e5e <printint+0x8e>
    80005e34:	fd040793          	addi	a5,s0,-48
    80005e38:	00e784b3          	add	s1,a5,a4
    80005e3c:	fff78913          	addi	s2,a5,-1
    80005e40:	993a                	add	s2,s2,a4
    80005e42:	377d                	addiw	a4,a4,-1
    80005e44:	1702                	slli	a4,a4,0x20
    80005e46:	9301                	srli	a4,a4,0x20
    80005e48:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005e4c:	fff4c503          	lbu	a0,-1(s1)
    80005e50:	00000097          	auipc	ra,0x0
    80005e54:	d60080e7          	jalr	-672(ra) # 80005bb0 <consputc>
  while(--i >= 0)
    80005e58:	14fd                	addi	s1,s1,-1
    80005e5a:	ff2499e3          	bne	s1,s2,80005e4c <printint+0x7c>
}
    80005e5e:	70a2                	ld	ra,40(sp)
    80005e60:	7402                	ld	s0,32(sp)
    80005e62:	64e2                	ld	s1,24(sp)
    80005e64:	6942                	ld	s2,16(sp)
    80005e66:	6145                	addi	sp,sp,48
    80005e68:	8082                	ret
    x = -xx;
    80005e6a:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005e6e:	4885                	li	a7,1
    x = -xx;
    80005e70:	bf9d                	j	80005de6 <printint+0x16>

0000000080005e72 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005e72:	1101                	addi	sp,sp,-32
    80005e74:	ec06                	sd	ra,24(sp)
    80005e76:	e822                	sd	s0,16(sp)
    80005e78:	e426                	sd	s1,8(sp)
    80005e7a:	1000                	addi	s0,sp,32
    80005e7c:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005e7e:	0001c797          	auipc	a5,0x1c
    80005e82:	1407a123          	sw	zero,322(a5) # 80021fc0 <pr+0x18>
  printf("panic: ");
    80005e86:	00003517          	auipc	a0,0x3
    80005e8a:	9ea50513          	addi	a0,a0,-1558 # 80008870 <syscalls+0x440>
    80005e8e:	00000097          	auipc	ra,0x0
    80005e92:	02e080e7          	jalr	46(ra) # 80005ebc <printf>
  printf(s);
    80005e96:	8526                	mv	a0,s1
    80005e98:	00000097          	auipc	ra,0x0
    80005e9c:	024080e7          	jalr	36(ra) # 80005ebc <printf>
  printf("\n");
    80005ea0:	00002517          	auipc	a0,0x2
    80005ea4:	1a850513          	addi	a0,a0,424 # 80008048 <etext+0x48>
    80005ea8:	00000097          	auipc	ra,0x0
    80005eac:	014080e7          	jalr	20(ra) # 80005ebc <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005eb0:	4785                	li	a5,1
    80005eb2:	00003717          	auipc	a4,0x3
    80005eb6:	acf72523          	sw	a5,-1334(a4) # 8000897c <panicked>
  for(;;)
    80005eba:	a001                	j	80005eba <panic+0x48>

0000000080005ebc <printf>:
{
    80005ebc:	7131                	addi	sp,sp,-192
    80005ebe:	fc86                	sd	ra,120(sp)
    80005ec0:	f8a2                	sd	s0,112(sp)
    80005ec2:	f4a6                	sd	s1,104(sp)
    80005ec4:	f0ca                	sd	s2,96(sp)
    80005ec6:	ecce                	sd	s3,88(sp)
    80005ec8:	e8d2                	sd	s4,80(sp)
    80005eca:	e4d6                	sd	s5,72(sp)
    80005ecc:	e0da                	sd	s6,64(sp)
    80005ece:	fc5e                	sd	s7,56(sp)
    80005ed0:	f862                	sd	s8,48(sp)
    80005ed2:	f466                	sd	s9,40(sp)
    80005ed4:	f06a                	sd	s10,32(sp)
    80005ed6:	ec6e                	sd	s11,24(sp)
    80005ed8:	0100                	addi	s0,sp,128
    80005eda:	8a2a                	mv	s4,a0
    80005edc:	e40c                	sd	a1,8(s0)
    80005ede:	e810                	sd	a2,16(s0)
    80005ee0:	ec14                	sd	a3,24(s0)
    80005ee2:	f018                	sd	a4,32(s0)
    80005ee4:	f41c                	sd	a5,40(s0)
    80005ee6:	03043823          	sd	a6,48(s0)
    80005eea:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005eee:	0001cd97          	auipc	s11,0x1c
    80005ef2:	0d2dad83          	lw	s11,210(s11) # 80021fc0 <pr+0x18>
  if(locking)
    80005ef6:	020d9b63          	bnez	s11,80005f2c <printf+0x70>
  if (fmt == 0)
    80005efa:	040a0263          	beqz	s4,80005f3e <printf+0x82>
  va_start(ap, fmt);
    80005efe:	00840793          	addi	a5,s0,8
    80005f02:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005f06:	000a4503          	lbu	a0,0(s4)
    80005f0a:	16050263          	beqz	a0,8000606e <printf+0x1b2>
    80005f0e:	4481                	li	s1,0
    if(c != '%'){
    80005f10:	02500a93          	li	s5,37
    switch(c){
    80005f14:	07000b13          	li	s6,112
  consputc('x');
    80005f18:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005f1a:	00003b97          	auipc	s7,0x3
    80005f1e:	97eb8b93          	addi	s7,s7,-1666 # 80008898 <digits>
    switch(c){
    80005f22:	07300c93          	li	s9,115
    80005f26:	06400c13          	li	s8,100
    80005f2a:	a82d                	j	80005f64 <printf+0xa8>
    acquire(&pr.lock);
    80005f2c:	0001c517          	auipc	a0,0x1c
    80005f30:	07c50513          	addi	a0,a0,124 # 80021fa8 <pr>
    80005f34:	00000097          	auipc	ra,0x0
    80005f38:	488080e7          	jalr	1160(ra) # 800063bc <acquire>
    80005f3c:	bf7d                	j	80005efa <printf+0x3e>
    panic("null fmt");
    80005f3e:	00003517          	auipc	a0,0x3
    80005f42:	94250513          	addi	a0,a0,-1726 # 80008880 <syscalls+0x450>
    80005f46:	00000097          	auipc	ra,0x0
    80005f4a:	f2c080e7          	jalr	-212(ra) # 80005e72 <panic>
      consputc(c);
    80005f4e:	00000097          	auipc	ra,0x0
    80005f52:	c62080e7          	jalr	-926(ra) # 80005bb0 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005f56:	2485                	addiw	s1,s1,1
    80005f58:	009a07b3          	add	a5,s4,s1
    80005f5c:	0007c503          	lbu	a0,0(a5)
    80005f60:	10050763          	beqz	a0,8000606e <printf+0x1b2>
    if(c != '%'){
    80005f64:	ff5515e3          	bne	a0,s5,80005f4e <printf+0x92>
    c = fmt[++i] & 0xff;
    80005f68:	2485                	addiw	s1,s1,1
    80005f6a:	009a07b3          	add	a5,s4,s1
    80005f6e:	0007c783          	lbu	a5,0(a5)
    80005f72:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80005f76:	cfe5                	beqz	a5,8000606e <printf+0x1b2>
    switch(c){
    80005f78:	05678a63          	beq	a5,s6,80005fcc <printf+0x110>
    80005f7c:	02fb7663          	bgeu	s6,a5,80005fa8 <printf+0xec>
    80005f80:	09978963          	beq	a5,s9,80006012 <printf+0x156>
    80005f84:	07800713          	li	a4,120
    80005f88:	0ce79863          	bne	a5,a4,80006058 <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80005f8c:	f8843783          	ld	a5,-120(s0)
    80005f90:	00878713          	addi	a4,a5,8
    80005f94:	f8e43423          	sd	a4,-120(s0)
    80005f98:	4605                	li	a2,1
    80005f9a:	85ea                	mv	a1,s10
    80005f9c:	4388                	lw	a0,0(a5)
    80005f9e:	00000097          	auipc	ra,0x0
    80005fa2:	e32080e7          	jalr	-462(ra) # 80005dd0 <printint>
      break;
    80005fa6:	bf45                	j	80005f56 <printf+0x9a>
    switch(c){
    80005fa8:	0b578263          	beq	a5,s5,8000604c <printf+0x190>
    80005fac:	0b879663          	bne	a5,s8,80006058 <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80005fb0:	f8843783          	ld	a5,-120(s0)
    80005fb4:	00878713          	addi	a4,a5,8
    80005fb8:	f8e43423          	sd	a4,-120(s0)
    80005fbc:	4605                	li	a2,1
    80005fbe:	45a9                	li	a1,10
    80005fc0:	4388                	lw	a0,0(a5)
    80005fc2:	00000097          	auipc	ra,0x0
    80005fc6:	e0e080e7          	jalr	-498(ra) # 80005dd0 <printint>
      break;
    80005fca:	b771                	j	80005f56 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005fcc:	f8843783          	ld	a5,-120(s0)
    80005fd0:	00878713          	addi	a4,a5,8
    80005fd4:	f8e43423          	sd	a4,-120(s0)
    80005fd8:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005fdc:	03000513          	li	a0,48
    80005fe0:	00000097          	auipc	ra,0x0
    80005fe4:	bd0080e7          	jalr	-1072(ra) # 80005bb0 <consputc>
  consputc('x');
    80005fe8:	07800513          	li	a0,120
    80005fec:	00000097          	auipc	ra,0x0
    80005ff0:	bc4080e7          	jalr	-1084(ra) # 80005bb0 <consputc>
    80005ff4:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005ff6:	03c9d793          	srli	a5,s3,0x3c
    80005ffa:	97de                	add	a5,a5,s7
    80005ffc:	0007c503          	lbu	a0,0(a5)
    80006000:	00000097          	auipc	ra,0x0
    80006004:	bb0080e7          	jalr	-1104(ra) # 80005bb0 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80006008:	0992                	slli	s3,s3,0x4
    8000600a:	397d                	addiw	s2,s2,-1
    8000600c:	fe0915e3          	bnez	s2,80005ff6 <printf+0x13a>
    80006010:	b799                	j	80005f56 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80006012:	f8843783          	ld	a5,-120(s0)
    80006016:	00878713          	addi	a4,a5,8
    8000601a:	f8e43423          	sd	a4,-120(s0)
    8000601e:	0007b903          	ld	s2,0(a5)
    80006022:	00090e63          	beqz	s2,8000603e <printf+0x182>
      for(; *s; s++)
    80006026:	00094503          	lbu	a0,0(s2)
    8000602a:	d515                	beqz	a0,80005f56 <printf+0x9a>
        consputc(*s);
    8000602c:	00000097          	auipc	ra,0x0
    80006030:	b84080e7          	jalr	-1148(ra) # 80005bb0 <consputc>
      for(; *s; s++)
    80006034:	0905                	addi	s2,s2,1
    80006036:	00094503          	lbu	a0,0(s2)
    8000603a:	f96d                	bnez	a0,8000602c <printf+0x170>
    8000603c:	bf29                	j	80005f56 <printf+0x9a>
        s = "(null)";
    8000603e:	00003917          	auipc	s2,0x3
    80006042:	83a90913          	addi	s2,s2,-1990 # 80008878 <syscalls+0x448>
      for(; *s; s++)
    80006046:	02800513          	li	a0,40
    8000604a:	b7cd                	j	8000602c <printf+0x170>
      consputc('%');
    8000604c:	8556                	mv	a0,s5
    8000604e:	00000097          	auipc	ra,0x0
    80006052:	b62080e7          	jalr	-1182(ra) # 80005bb0 <consputc>
      break;
    80006056:	b701                	j	80005f56 <printf+0x9a>
      consputc('%');
    80006058:	8556                	mv	a0,s5
    8000605a:	00000097          	auipc	ra,0x0
    8000605e:	b56080e7          	jalr	-1194(ra) # 80005bb0 <consputc>
      consputc(c);
    80006062:	854a                	mv	a0,s2
    80006064:	00000097          	auipc	ra,0x0
    80006068:	b4c080e7          	jalr	-1204(ra) # 80005bb0 <consputc>
      break;
    8000606c:	b5ed                	j	80005f56 <printf+0x9a>
  if(locking)
    8000606e:	020d9163          	bnez	s11,80006090 <printf+0x1d4>
}
    80006072:	70e6                	ld	ra,120(sp)
    80006074:	7446                	ld	s0,112(sp)
    80006076:	74a6                	ld	s1,104(sp)
    80006078:	7906                	ld	s2,96(sp)
    8000607a:	69e6                	ld	s3,88(sp)
    8000607c:	6a46                	ld	s4,80(sp)
    8000607e:	6aa6                	ld	s5,72(sp)
    80006080:	6b06                	ld	s6,64(sp)
    80006082:	7be2                	ld	s7,56(sp)
    80006084:	7c42                	ld	s8,48(sp)
    80006086:	7ca2                	ld	s9,40(sp)
    80006088:	7d02                	ld	s10,32(sp)
    8000608a:	6de2                	ld	s11,24(sp)
    8000608c:	6129                	addi	sp,sp,192
    8000608e:	8082                	ret
    release(&pr.lock);
    80006090:	0001c517          	auipc	a0,0x1c
    80006094:	f1850513          	addi	a0,a0,-232 # 80021fa8 <pr>
    80006098:	00000097          	auipc	ra,0x0
    8000609c:	3d8080e7          	jalr	984(ra) # 80006470 <release>
}
    800060a0:	bfc9                	j	80006072 <printf+0x1b6>

00000000800060a2 <printfinit>:
    ;
}

void
printfinit(void)
{
    800060a2:	1101                	addi	sp,sp,-32
    800060a4:	ec06                	sd	ra,24(sp)
    800060a6:	e822                	sd	s0,16(sp)
    800060a8:	e426                	sd	s1,8(sp)
    800060aa:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800060ac:	0001c497          	auipc	s1,0x1c
    800060b0:	efc48493          	addi	s1,s1,-260 # 80021fa8 <pr>
    800060b4:	00002597          	auipc	a1,0x2
    800060b8:	7dc58593          	addi	a1,a1,2012 # 80008890 <syscalls+0x460>
    800060bc:	8526                	mv	a0,s1
    800060be:	00000097          	auipc	ra,0x0
    800060c2:	26e080e7          	jalr	622(ra) # 8000632c <initlock>
  pr.locking = 1;
    800060c6:	4785                	li	a5,1
    800060c8:	cc9c                	sw	a5,24(s1)
}
    800060ca:	60e2                	ld	ra,24(sp)
    800060cc:	6442                	ld	s0,16(sp)
    800060ce:	64a2                	ld	s1,8(sp)
    800060d0:	6105                	addi	sp,sp,32
    800060d2:	8082                	ret

00000000800060d4 <uartinit>:

void uartstart();

void
uartinit(void)
{
    800060d4:	1141                	addi	sp,sp,-16
    800060d6:	e406                	sd	ra,8(sp)
    800060d8:	e022                	sd	s0,0(sp)
    800060da:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800060dc:	100007b7          	lui	a5,0x10000
    800060e0:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800060e4:	f8000713          	li	a4,-128
    800060e8:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800060ec:	470d                	li	a4,3
    800060ee:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800060f2:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800060f6:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800060fa:	469d                	li	a3,7
    800060fc:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006100:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80006104:	00002597          	auipc	a1,0x2
    80006108:	7ac58593          	addi	a1,a1,1964 # 800088b0 <digits+0x18>
    8000610c:	0001c517          	auipc	a0,0x1c
    80006110:	ebc50513          	addi	a0,a0,-324 # 80021fc8 <uart_tx_lock>
    80006114:	00000097          	auipc	ra,0x0
    80006118:	218080e7          	jalr	536(ra) # 8000632c <initlock>
}
    8000611c:	60a2                	ld	ra,8(sp)
    8000611e:	6402                	ld	s0,0(sp)
    80006120:	0141                	addi	sp,sp,16
    80006122:	8082                	ret

0000000080006124 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80006124:	1101                	addi	sp,sp,-32
    80006126:	ec06                	sd	ra,24(sp)
    80006128:	e822                	sd	s0,16(sp)
    8000612a:	e426                	sd	s1,8(sp)
    8000612c:	1000                	addi	s0,sp,32
    8000612e:	84aa                	mv	s1,a0
  push_off();
    80006130:	00000097          	auipc	ra,0x0
    80006134:	240080e7          	jalr	576(ra) # 80006370 <push_off>

  if(panicked){
    80006138:	00003797          	auipc	a5,0x3
    8000613c:	8447a783          	lw	a5,-1980(a5) # 8000897c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006140:	10000737          	lui	a4,0x10000
  if(panicked){
    80006144:	c391                	beqz	a5,80006148 <uartputc_sync+0x24>
    for(;;)
    80006146:	a001                	j	80006146 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006148:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    8000614c:	0ff7f793          	andi	a5,a5,255
    80006150:	0207f793          	andi	a5,a5,32
    80006154:	dbf5                	beqz	a5,80006148 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80006156:	0ff4f793          	andi	a5,s1,255
    8000615a:	10000737          	lui	a4,0x10000
    8000615e:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80006162:	00000097          	auipc	ra,0x0
    80006166:	2ae080e7          	jalr	686(ra) # 80006410 <pop_off>
}
    8000616a:	60e2                	ld	ra,24(sp)
    8000616c:	6442                	ld	s0,16(sp)
    8000616e:	64a2                	ld	s1,8(sp)
    80006170:	6105                	addi	sp,sp,32
    80006172:	8082                	ret

0000000080006174 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80006174:	00003717          	auipc	a4,0x3
    80006178:	80c73703          	ld	a4,-2036(a4) # 80008980 <uart_tx_r>
    8000617c:	00003797          	auipc	a5,0x3
    80006180:	80c7b783          	ld	a5,-2036(a5) # 80008988 <uart_tx_w>
    80006184:	06e78c63          	beq	a5,a4,800061fc <uartstart+0x88>
{
    80006188:	7139                	addi	sp,sp,-64
    8000618a:	fc06                	sd	ra,56(sp)
    8000618c:	f822                	sd	s0,48(sp)
    8000618e:	f426                	sd	s1,40(sp)
    80006190:	f04a                	sd	s2,32(sp)
    80006192:	ec4e                	sd	s3,24(sp)
    80006194:	e852                	sd	s4,16(sp)
    80006196:	e456                	sd	s5,8(sp)
    80006198:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000619a:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000619e:	0001ca17          	auipc	s4,0x1c
    800061a2:	e2aa0a13          	addi	s4,s4,-470 # 80021fc8 <uart_tx_lock>
    uart_tx_r += 1;
    800061a6:	00002497          	auipc	s1,0x2
    800061aa:	7da48493          	addi	s1,s1,2010 # 80008980 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    800061ae:	00002997          	auipc	s3,0x2
    800061b2:	7da98993          	addi	s3,s3,2010 # 80008988 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800061b6:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    800061ba:	0ff7f793          	andi	a5,a5,255
    800061be:	0207f793          	andi	a5,a5,32
    800061c2:	c785                	beqz	a5,800061ea <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800061c4:	01f77793          	andi	a5,a4,31
    800061c8:	97d2                	add	a5,a5,s4
    800061ca:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    800061ce:	0705                	addi	a4,a4,1
    800061d0:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    800061d2:	8526                	mv	a0,s1
    800061d4:	ffffb097          	auipc	ra,0xffffb
    800061d8:	53c080e7          	jalr	1340(ra) # 80001710 <wakeup>
    
    WriteReg(THR, c);
    800061dc:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    800061e0:	6098                	ld	a4,0(s1)
    800061e2:	0009b783          	ld	a5,0(s3)
    800061e6:	fce798e3          	bne	a5,a4,800061b6 <uartstart+0x42>
  }
}
    800061ea:	70e2                	ld	ra,56(sp)
    800061ec:	7442                	ld	s0,48(sp)
    800061ee:	74a2                	ld	s1,40(sp)
    800061f0:	7902                	ld	s2,32(sp)
    800061f2:	69e2                	ld	s3,24(sp)
    800061f4:	6a42                	ld	s4,16(sp)
    800061f6:	6aa2                	ld	s5,8(sp)
    800061f8:	6121                	addi	sp,sp,64
    800061fa:	8082                	ret
    800061fc:	8082                	ret

00000000800061fe <uartputc>:
{
    800061fe:	7179                	addi	sp,sp,-48
    80006200:	f406                	sd	ra,40(sp)
    80006202:	f022                	sd	s0,32(sp)
    80006204:	ec26                	sd	s1,24(sp)
    80006206:	e84a                	sd	s2,16(sp)
    80006208:	e44e                	sd	s3,8(sp)
    8000620a:	e052                	sd	s4,0(sp)
    8000620c:	1800                	addi	s0,sp,48
    8000620e:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    80006210:	0001c517          	auipc	a0,0x1c
    80006214:	db850513          	addi	a0,a0,-584 # 80021fc8 <uart_tx_lock>
    80006218:	00000097          	auipc	ra,0x0
    8000621c:	1a4080e7          	jalr	420(ra) # 800063bc <acquire>
  if(panicked){
    80006220:	00002797          	auipc	a5,0x2
    80006224:	75c7a783          	lw	a5,1884(a5) # 8000897c <panicked>
    80006228:	e7c9                	bnez	a5,800062b2 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000622a:	00002797          	auipc	a5,0x2
    8000622e:	75e7b783          	ld	a5,1886(a5) # 80008988 <uart_tx_w>
    80006232:	00002717          	auipc	a4,0x2
    80006236:	74e73703          	ld	a4,1870(a4) # 80008980 <uart_tx_r>
    8000623a:	02070713          	addi	a4,a4,32
    sleep(&uart_tx_r, &uart_tx_lock);
    8000623e:	0001ca17          	auipc	s4,0x1c
    80006242:	d8aa0a13          	addi	s4,s4,-630 # 80021fc8 <uart_tx_lock>
    80006246:	00002497          	auipc	s1,0x2
    8000624a:	73a48493          	addi	s1,s1,1850 # 80008980 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000624e:	00002917          	auipc	s2,0x2
    80006252:	73a90913          	addi	s2,s2,1850 # 80008988 <uart_tx_w>
    80006256:	00f71f63          	bne	a4,a5,80006274 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    8000625a:	85d2                	mv	a1,s4
    8000625c:	8526                	mv	a0,s1
    8000625e:	ffffb097          	auipc	ra,0xffffb
    80006262:	44e080e7          	jalr	1102(ra) # 800016ac <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006266:	00093783          	ld	a5,0(s2)
    8000626a:	6098                	ld	a4,0(s1)
    8000626c:	02070713          	addi	a4,a4,32
    80006270:	fef705e3          	beq	a4,a5,8000625a <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006274:	0001c497          	auipc	s1,0x1c
    80006278:	d5448493          	addi	s1,s1,-684 # 80021fc8 <uart_tx_lock>
    8000627c:	01f7f713          	andi	a4,a5,31
    80006280:	9726                	add	a4,a4,s1
    80006282:	01370c23          	sb	s3,24(a4)
  uart_tx_w += 1;
    80006286:	0785                	addi	a5,a5,1
    80006288:	00002717          	auipc	a4,0x2
    8000628c:	70f73023          	sd	a5,1792(a4) # 80008988 <uart_tx_w>
  uartstart();
    80006290:	00000097          	auipc	ra,0x0
    80006294:	ee4080e7          	jalr	-284(ra) # 80006174 <uartstart>
  release(&uart_tx_lock);
    80006298:	8526                	mv	a0,s1
    8000629a:	00000097          	auipc	ra,0x0
    8000629e:	1d6080e7          	jalr	470(ra) # 80006470 <release>
}
    800062a2:	70a2                	ld	ra,40(sp)
    800062a4:	7402                	ld	s0,32(sp)
    800062a6:	64e2                	ld	s1,24(sp)
    800062a8:	6942                	ld	s2,16(sp)
    800062aa:	69a2                	ld	s3,8(sp)
    800062ac:	6a02                	ld	s4,0(sp)
    800062ae:	6145                	addi	sp,sp,48
    800062b0:	8082                	ret
    for(;;)
    800062b2:	a001                	j	800062b2 <uartputc+0xb4>

00000000800062b4 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800062b4:	1141                	addi	sp,sp,-16
    800062b6:	e422                	sd	s0,8(sp)
    800062b8:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800062ba:	100007b7          	lui	a5,0x10000
    800062be:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800062c2:	8b85                	andi	a5,a5,1
    800062c4:	cb91                	beqz	a5,800062d8 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800062c6:	100007b7          	lui	a5,0x10000
    800062ca:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    800062ce:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    800062d2:	6422                	ld	s0,8(sp)
    800062d4:	0141                	addi	sp,sp,16
    800062d6:	8082                	ret
    return -1;
    800062d8:	557d                	li	a0,-1
    800062da:	bfe5                	j	800062d2 <uartgetc+0x1e>

00000000800062dc <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800062dc:	1101                	addi	sp,sp,-32
    800062de:	ec06                	sd	ra,24(sp)
    800062e0:	e822                	sd	s0,16(sp)
    800062e2:	e426                	sd	s1,8(sp)
    800062e4:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800062e6:	54fd                	li	s1,-1
    int c = uartgetc();
    800062e8:	00000097          	auipc	ra,0x0
    800062ec:	fcc080e7          	jalr	-52(ra) # 800062b4 <uartgetc>
    if(c == -1)
    800062f0:	00950763          	beq	a0,s1,800062fe <uartintr+0x22>
      break;
    consoleintr(c);
    800062f4:	00000097          	auipc	ra,0x0
    800062f8:	8fe080e7          	jalr	-1794(ra) # 80005bf2 <consoleintr>
  while(1){
    800062fc:	b7f5                	j	800062e8 <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800062fe:	0001c497          	auipc	s1,0x1c
    80006302:	cca48493          	addi	s1,s1,-822 # 80021fc8 <uart_tx_lock>
    80006306:	8526                	mv	a0,s1
    80006308:	00000097          	auipc	ra,0x0
    8000630c:	0b4080e7          	jalr	180(ra) # 800063bc <acquire>
  uartstart();
    80006310:	00000097          	auipc	ra,0x0
    80006314:	e64080e7          	jalr	-412(ra) # 80006174 <uartstart>
  release(&uart_tx_lock);
    80006318:	8526                	mv	a0,s1
    8000631a:	00000097          	auipc	ra,0x0
    8000631e:	156080e7          	jalr	342(ra) # 80006470 <release>
}
    80006322:	60e2                	ld	ra,24(sp)
    80006324:	6442                	ld	s0,16(sp)
    80006326:	64a2                	ld	s1,8(sp)
    80006328:	6105                	addi	sp,sp,32
    8000632a:	8082                	ret

000000008000632c <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    8000632c:	1141                	addi	sp,sp,-16
    8000632e:	e422                	sd	s0,8(sp)
    80006330:	0800                	addi	s0,sp,16
  lk->name = name;
    80006332:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006334:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006338:	00053823          	sd	zero,16(a0)
}
    8000633c:	6422                	ld	s0,8(sp)
    8000633e:	0141                	addi	sp,sp,16
    80006340:	8082                	ret

0000000080006342 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006342:	411c                	lw	a5,0(a0)
    80006344:	e399                	bnez	a5,8000634a <holding+0x8>
    80006346:	4501                	li	a0,0
  return r;
}
    80006348:	8082                	ret
{
    8000634a:	1101                	addi	sp,sp,-32
    8000634c:	ec06                	sd	ra,24(sp)
    8000634e:	e822                	sd	s0,16(sp)
    80006350:	e426                	sd	s1,8(sp)
    80006352:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006354:	6904                	ld	s1,16(a0)
    80006356:	ffffb097          	auipc	ra,0xffffb
    8000635a:	bce080e7          	jalr	-1074(ra) # 80000f24 <mycpu>
    8000635e:	40a48533          	sub	a0,s1,a0
    80006362:	00153513          	seqz	a0,a0
}
    80006366:	60e2                	ld	ra,24(sp)
    80006368:	6442                	ld	s0,16(sp)
    8000636a:	64a2                	ld	s1,8(sp)
    8000636c:	6105                	addi	sp,sp,32
    8000636e:	8082                	ret

0000000080006370 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006370:	1101                	addi	sp,sp,-32
    80006372:	ec06                	sd	ra,24(sp)
    80006374:	e822                	sd	s0,16(sp)
    80006376:	e426                	sd	s1,8(sp)
    80006378:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000637a:	100024f3          	csrr	s1,sstatus
    8000637e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006382:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006384:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006388:	ffffb097          	auipc	ra,0xffffb
    8000638c:	b9c080e7          	jalr	-1124(ra) # 80000f24 <mycpu>
    80006390:	5d3c                	lw	a5,120(a0)
    80006392:	cf89                	beqz	a5,800063ac <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006394:	ffffb097          	auipc	ra,0xffffb
    80006398:	b90080e7          	jalr	-1136(ra) # 80000f24 <mycpu>
    8000639c:	5d3c                	lw	a5,120(a0)
    8000639e:	2785                	addiw	a5,a5,1
    800063a0:	dd3c                	sw	a5,120(a0)
}
    800063a2:	60e2                	ld	ra,24(sp)
    800063a4:	6442                	ld	s0,16(sp)
    800063a6:	64a2                	ld	s1,8(sp)
    800063a8:	6105                	addi	sp,sp,32
    800063aa:	8082                	ret
    mycpu()->intena = old;
    800063ac:	ffffb097          	auipc	ra,0xffffb
    800063b0:	b78080e7          	jalr	-1160(ra) # 80000f24 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800063b4:	8085                	srli	s1,s1,0x1
    800063b6:	8885                	andi	s1,s1,1
    800063b8:	dd64                	sw	s1,124(a0)
    800063ba:	bfe9                	j	80006394 <push_off+0x24>

00000000800063bc <acquire>:
{
    800063bc:	1101                	addi	sp,sp,-32
    800063be:	ec06                	sd	ra,24(sp)
    800063c0:	e822                	sd	s0,16(sp)
    800063c2:	e426                	sd	s1,8(sp)
    800063c4:	1000                	addi	s0,sp,32
    800063c6:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800063c8:	00000097          	auipc	ra,0x0
    800063cc:	fa8080e7          	jalr	-88(ra) # 80006370 <push_off>
  if(holding(lk))
    800063d0:	8526                	mv	a0,s1
    800063d2:	00000097          	auipc	ra,0x0
    800063d6:	f70080e7          	jalr	-144(ra) # 80006342 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800063da:	4705                	li	a4,1
  if(holding(lk))
    800063dc:	e115                	bnez	a0,80006400 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800063de:	87ba                	mv	a5,a4
    800063e0:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800063e4:	2781                	sext.w	a5,a5
    800063e6:	ffe5                	bnez	a5,800063de <acquire+0x22>
  __sync_synchronize();
    800063e8:	0ff0000f          	fence
  lk->cpu = mycpu();
    800063ec:	ffffb097          	auipc	ra,0xffffb
    800063f0:	b38080e7          	jalr	-1224(ra) # 80000f24 <mycpu>
    800063f4:	e888                	sd	a0,16(s1)
}
    800063f6:	60e2                	ld	ra,24(sp)
    800063f8:	6442                	ld	s0,16(sp)
    800063fa:	64a2                	ld	s1,8(sp)
    800063fc:	6105                	addi	sp,sp,32
    800063fe:	8082                	ret
    panic("acquire");
    80006400:	00002517          	auipc	a0,0x2
    80006404:	4b850513          	addi	a0,a0,1208 # 800088b8 <digits+0x20>
    80006408:	00000097          	auipc	ra,0x0
    8000640c:	a6a080e7          	jalr	-1430(ra) # 80005e72 <panic>

0000000080006410 <pop_off>:

void
pop_off(void)
{
    80006410:	1141                	addi	sp,sp,-16
    80006412:	e406                	sd	ra,8(sp)
    80006414:	e022                	sd	s0,0(sp)
    80006416:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006418:	ffffb097          	auipc	ra,0xffffb
    8000641c:	b0c080e7          	jalr	-1268(ra) # 80000f24 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006420:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006424:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006426:	e78d                	bnez	a5,80006450 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006428:	5d3c                	lw	a5,120(a0)
    8000642a:	02f05b63          	blez	a5,80006460 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    8000642e:	37fd                	addiw	a5,a5,-1
    80006430:	0007871b          	sext.w	a4,a5
    80006434:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006436:	eb09                	bnez	a4,80006448 <pop_off+0x38>
    80006438:	5d7c                	lw	a5,124(a0)
    8000643a:	c799                	beqz	a5,80006448 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000643c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006440:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006444:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006448:	60a2                	ld	ra,8(sp)
    8000644a:	6402                	ld	s0,0(sp)
    8000644c:	0141                	addi	sp,sp,16
    8000644e:	8082                	ret
    panic("pop_off - interruptible");
    80006450:	00002517          	auipc	a0,0x2
    80006454:	47050513          	addi	a0,a0,1136 # 800088c0 <digits+0x28>
    80006458:	00000097          	auipc	ra,0x0
    8000645c:	a1a080e7          	jalr	-1510(ra) # 80005e72 <panic>
    panic("pop_off");
    80006460:	00002517          	auipc	a0,0x2
    80006464:	47850513          	addi	a0,a0,1144 # 800088d8 <digits+0x40>
    80006468:	00000097          	auipc	ra,0x0
    8000646c:	a0a080e7          	jalr	-1526(ra) # 80005e72 <panic>

0000000080006470 <release>:
{
    80006470:	1101                	addi	sp,sp,-32
    80006472:	ec06                	sd	ra,24(sp)
    80006474:	e822                	sd	s0,16(sp)
    80006476:	e426                	sd	s1,8(sp)
    80006478:	1000                	addi	s0,sp,32
    8000647a:	84aa                	mv	s1,a0
  if(!holding(lk))
    8000647c:	00000097          	auipc	ra,0x0
    80006480:	ec6080e7          	jalr	-314(ra) # 80006342 <holding>
    80006484:	c115                	beqz	a0,800064a8 <release+0x38>
  lk->cpu = 0;
    80006486:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    8000648a:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    8000648e:	0f50000f          	fence	iorw,ow
    80006492:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80006496:	00000097          	auipc	ra,0x0
    8000649a:	f7a080e7          	jalr	-134(ra) # 80006410 <pop_off>
}
    8000649e:	60e2                	ld	ra,24(sp)
    800064a0:	6442                	ld	s0,16(sp)
    800064a2:	64a2                	ld	s1,8(sp)
    800064a4:	6105                	addi	sp,sp,32
    800064a6:	8082                	ret
    panic("release");
    800064a8:	00002517          	auipc	a0,0x2
    800064ac:	43850513          	addi	a0,a0,1080 # 800088e0 <digits+0x48>
    800064b0:	00000097          	auipc	ra,0x0
    800064b4:	9c2080e7          	jalr	-1598(ra) # 80005e72 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
