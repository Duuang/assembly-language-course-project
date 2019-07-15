

// 伪代码
main() {
  byte op1[200]  //被乘数
  byte op2[200]  //乘数
  byte middle_result[201]  //中间结果
  byte result[400]   //结果
  输入两个数到op1和op2
    for (op2从最后一位到第一位) {
    //计算中间结果，op1 位 × op2位再相加; 
    for op1从最后一位到第一位{
      中间结果对应位 = (两位相乘 + carry) / 10的余数
      carry = (两位相乘 + carry) / 10的商
    }
    if 中间结果最后一位还有进位{
      中间结果最后一位为进位
    } 
    //将中间结果与result相加，将middle_result和result对应位相加
    for middle_result最后一位到第一位
    {
      result对应位 = (两位相加 + carry) / 10 的余数
      carry = (两位相加 + carry) / 10 的商
    }
    if 最后一位还有进位（两数相加进位只能为0或1）{
      result最后一位设为1
    }     
    //打印结果
    for result从最后一位到第一位{
      如果为0，不打印
      从第一个不为0的位开始打印，一直打印到result[0]
    }
}


