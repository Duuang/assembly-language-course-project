// MFCApplication2Dlg.cpp: 实现文件
//

#include "stdafx.h"
#include "MFCApplication2.h"
#include "MFCApplication2Dlg.h"
#include "afxdialogex.h"
#include <math.h>

#ifdef _DEBUG
#define new DEBUG_NEW
#endif


//全局变量
char output[105];  //输出到屏幕的字符串，和屏幕同步，也作为保存输入字符串的地方
int outputlen;      //output[]长度
int if_last_result = 0;    //现在时刻output[]中的屏幕输出是否可被下一数字键清除
float middle_result;      //保存中间结果，为计算器的缓存
int if_middle_int;        //中间结果是否为整数
int if_middle_valid;      //缓存区是否为空（中间结果是否可用）
int last_op;              //缓存上一次输入的操作符

extern "C" void __cdecl  NumberButtonClicked(char *out, int *outlen, char number, int * if_last);
extern "C" void __cdecl CalcSin(char *output,int *outputlen, float *middle_result, int *if_middle_int, int op);
extern "C" void __cdecl ClearInput(char *out, int *outlen);
extern "C" void __cdecl BasicCalc(char *output,int *outputlen, float *middle_result, int *if_middle_int, int op, int *if_middle_valid, int *last_op, int if_last_result);
// CMFCApplication2Dlg 对话框



CMFCApplication2Dlg::CMFCApplication2Dlg(CWnd* pParent /*=nullptr*/)
	: CDialogEx(IDD_MFCAPPLICATION2_DIALOG, pParent)
{
  
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
    //-----------------变量初始化-------------------------------------------
  memset(output, 0, sizeof(output));
  outputlen = 1;
  output[0] = '0';
  if_middle_valid = 0;
  
  

}

void CMFCApplication2Dlg::DoDataExchange(CDataExchange* pDX)
{
	CDialogEx::DoDataExchange(pDX);
}

BEGIN_MESSAGE_MAP(CMFCApplication2Dlg, CDialogEx)
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
  ON_BN_CLICKED(IDC_BUTTON1, &CMFCApplication2Dlg::OnBnClickedButton1)
  ON_EN_CHANGE(IDC_EDIT1, &CMFCApplication2Dlg::OnEnChangeEdit1)
  ON_BN_CLICKED(IDC_BUTTON2, &CMFCApplication2Dlg::OnBnClickedButton2)
  ON_BN_CLICKED(IDC_BUTTON3, &CMFCApplication2Dlg::OnBnClickedButton3)
  ON_BN_CLICKED(IDC_BUTTON4, &CMFCApplication2Dlg::OnBnClickedButton4)
  ON_BN_CLICKED(IDC_BUTTON5, &CMFCApplication2Dlg::OnBnClickedButton5)
  ON_BN_CLICKED(IDC_BUTTON6, &CMFCApplication2Dlg::OnBnClickedButton6)
  ON_BN_CLICKED(IDC_BUTTON7, &CMFCApplication2Dlg::OnBnClickedButton7)
  ON_BN_CLICKED(IDC_BUTTON8, &CMFCApplication2Dlg::OnBnClickedButton8)
  ON_BN_CLICKED(IDC_BUTTON9, &CMFCApplication2Dlg::OnBnClickedButton9)
  ON_BN_CLICKED(IDC_BUTTON11, &CMFCApplication2Dlg::OnBnClickedButton11)
  ON_BN_CLICKED(IDC_BUTTON12, &CMFCApplication2Dlg::OnBnClickedButton12)
  ON_BN_CLICKED(IDC_BUTTON14, &CMFCApplication2Dlg::OnBnClickedButton14)
  ON_BN_CLICKED(IDC_BUTTON17, &CMFCApplication2Dlg::OnBnClickedButton17)
  ON_BN_CLICKED(IDC_BUTTON20, &CMFCApplication2Dlg::OnBnClickedButton20)
  ON_BN_CLICKED(IDC_BUTTON13, &CMFCApplication2Dlg::OnBnClickedButton13)
  ON_BN_CLICKED(IDC_BUTTON16, &CMFCApplication2Dlg::OnBnClickedButton16)
  ON_BN_CLICKED(IDC_BUTTON19, &CMFCApplication2Dlg::OnBnClickedButton19)
  ON_BN_CLICKED(IDC_BUTTON22, &CMFCApplication2Dlg::OnBnClickedButton22)
  ON_BN_CLICKED(IDC_BUTTON24, &CMFCApplication2Dlg::OnBnClickedButton24)
  ON_BN_CLICKED(IDC_BUTTON15, &CMFCApplication2Dlg::OnBnClickedButton15)
  ON_BN_CLICKED(IDC_BUTTON25, &CMFCApplication2Dlg::OnBnClickedButton25)
END_MESSAGE_MAP()


// CMFCApplication2Dlg 消息处理程序

BOOL CMFCApplication2Dlg::OnInitDialog()
{
	CDialogEx::OnInitDialog();

	// 设置此对话框的图标。  当应用程序主窗口不是对话框时，框架将自动
	//  执行此操作
	SetIcon(m_hIcon, TRUE);			// 设置大图标
	SetIcon(m_hIcon, FALSE);		// 设置小图标

	// TODO: 在此添加额外的初始化代码

	return TRUE;  // 除非将焦点设置到控件，否则返回 TRUE
}

// 如果向对话框添加最小化按钮，则需要下面的代码
//  来绘制该图标。  对于使用文档/视图模型的 MFC 应用程序，
//  这将由框架自动完成。

void CMFCApplication2Dlg::OnPaint()
{
	if (IsIconic())
	{
		CPaintDC dc(this); // 用于绘制的设备上下文

		SendMessage(WM_ICONERASEBKGND, reinterpret_cast<WPARAM>(dc.GetSafeHdc()), 0);

		// 使图标在工作区矩形中居中
		int cxIcon = GetSystemMetrics(SM_CXICON);
		int cyIcon = GetSystemMetrics(SM_CYICON);
		CRect rect;
		GetClientRect(&rect);
		int x = (rect.Width() - cxIcon + 1) / 2;
		int y = (rect.Height() - cyIcon + 1) / 2;

		// 绘制图标
		dc.DrawIcon(x, y, m_hIcon);
	}
	else
	{
		CDialogEx::OnPaint();
	}
}

//当用户拖动最小化窗口时系统调用此函数取得光标
//显示。
HCURSOR CMFCApplication2Dlg::OnQueryDragIcon()
{
	return static_cast<HCURSOR>(m_hIcon);
}


//按键1,之后的函数为按键2~9
void CMFCApplication2Dlg::OnBnClickedButton1()
{
  NumberButtonClicked(output, &outputlen, 1, &if_last_result);
  //在editbox输出字符串
  CEdit* editbox;
  editbox = (CEdit*) GetDlgItem(IDC_EDIT1);  //根据ID获取控件的指针
  int num = MultiByteToWideChar(0,0,output,-1,NULL,0);   //将char 转换为 WideChar
  wchar_t *wide = new wchar_t[num];
  MultiByteToWideChar(0,0,output,-1,wide,num);
  editbox->SetWindowTextW(wide);
}


void CMFCApplication2Dlg::OnEnChangeEdit1()
{
  // TODO:  如果该控件是 RICHEDIT 控件，它将不
  // 发送此通知，除非重写 CDialogEx::OnInitDialog()
  // 函数并调用 CRichEditCtrl().SetEventMask()，
  // 同时将 ENM_CHANGE 标志“或”运算到掩码中。

  // TODO:  在此添加控件通知处理程序代码
}


void CMFCApplication2Dlg::OnBnClickedButton2()
{
 NumberButtonClicked(output, &outputlen, 2, &if_last_result);
  //在editbox输出字符串
  CEdit* editbox;
  editbox = (CEdit*) GetDlgItem(IDC_EDIT1);
  int num = MultiByteToWideChar(0,0,output,-1,NULL,0);
  wchar_t *wide = new wchar_t[num];
  MultiByteToWideChar(0,0,output,-1,wide,num);
  editbox->SetWindowTextW(wide);
}


void CMFCApplication2Dlg::OnBnClickedButton3()
{
  NumberButtonClicked(output, &outputlen, 3, &if_last_result);
  //在editbox输出字符串
  CEdit* editbox;
  editbox = (CEdit*) GetDlgItem(IDC_EDIT1);
  int num = MultiByteToWideChar(0,0,output,-1,NULL,0);
  wchar_t *wide = new wchar_t[num];
  MultiByteToWideChar(0,0,output,-1,wide,num);
  editbox->SetWindowTextW(wide);
}


void CMFCApplication2Dlg::OnBnClickedButton4()
{
  NumberButtonClicked(output, &outputlen, 4, &if_last_result);
  //在editbox输出字符串
  CEdit* editbox;
  editbox = (CEdit*) GetDlgItem(IDC_EDIT1);
  int num = MultiByteToWideChar(0,0,output,-1,NULL,0);
  wchar_t *wide = new wchar_t[num];
  MultiByteToWideChar(0,0,output,-1,wide,num);
  editbox->SetWindowTextW(wide);
}


void CMFCApplication2Dlg::OnBnClickedButton5()
{
  NumberButtonClicked(output, &outputlen, 5, &if_last_result);
  //在editbox输出字符串
  CEdit* editbox;
  editbox = (CEdit*) GetDlgItem(IDC_EDIT1);
  int num = MultiByteToWideChar(0,0,output,-1,NULL,0);
  wchar_t *wide = new wchar_t[num];
  MultiByteToWideChar(0,0,output,-1,wide,num);
  editbox->SetWindowTextW(wide);
}


void CMFCApplication2Dlg::OnBnClickedButton6()
{
  NumberButtonClicked(output, &outputlen, 6, &if_last_result);
  //在editbox输出字符串
  CEdit* editbox;
  editbox = (CEdit*) GetDlgItem(IDC_EDIT1);
  int num = MultiByteToWideChar(0,0,output,-1,NULL,0);
  wchar_t *wide = new wchar_t[num];
  MultiByteToWideChar(0,0,output,-1,wide,num);
  editbox->SetWindowTextW(wide);
}


void CMFCApplication2Dlg::OnBnClickedButton7()
{
  NumberButtonClicked(output, &outputlen, 7, &if_last_result);
  //在editbox输出字符串
  CEdit* editbox;
  editbox = (CEdit*) GetDlgItem(IDC_EDIT1);
  int num = MultiByteToWideChar(0,0,output,-1,NULL,0);
  wchar_t *wide = new wchar_t[num];
  MultiByteToWideChar(0,0,output,-1,wide,num);
  editbox->SetWindowTextW(wide);
}


void CMFCApplication2Dlg::OnBnClickedButton8()
{
  NumberButtonClicked(output, &outputlen, 8, &if_last_result);
  //在editbox输出字符串
  CEdit* editbox;
  editbox = (CEdit*) GetDlgItem(IDC_EDIT1);
  int num = MultiByteToWideChar(0,0,output,-1,NULL,0);
  wchar_t *wide = new wchar_t[num];
  MultiByteToWideChar(0,0,output,-1,wide,num);
  editbox->SetWindowTextW(wide);
}


void CMFCApplication2Dlg::OnBnClickedButton9()
{
  NumberButtonClicked(output, &outputlen, 9, &if_last_result);
  //在editbox输出字符串
  CEdit* editbox;
  editbox = (CEdit*) GetDlgItem(IDC_EDIT1);
  int num = MultiByteToWideChar(0,0,output,-1,NULL,0);
  wchar_t *wide = new wchar_t[num];
  MultiByteToWideChar(0,0,output,-1,wide,num);
  editbox->SetWindowTextW(wide);
}


void CMFCApplication2Dlg::OnBnClickedButton11()
{
  NumberButtonClicked(output, &outputlen, 0, &if_last_result);
  //在editbox输出字符串
  CEdit* editbox;
  editbox = (CEdit*) GetDlgItem(IDC_EDIT1);
  int num = MultiByteToWideChar(0,0,output,-1,NULL,0);
  wchar_t *wide = new wchar_t[num];
  MultiByteToWideChar(0,0,output,-1,wide,num);
  editbox->SetWindowTextW(wide);
}

//按键.
void CMFCApplication2Dlg::OnBnClickedButton12()
{
  NumberButtonClicked(output, &outputlen, 10, &if_last_result);
  //在editbox输出字符串
  CEdit* editbox;
  editbox = (CEdit*) GetDlgItem(IDC_EDIT1);
  int num = MultiByteToWideChar(0,0,output,-1,NULL,0);
  wchar_t *wide = new wchar_t[num];
  MultiByteToWideChar(0,0,output,-1,wide,num);
  editbox->SetWindowTextW(wide);
}

//sin
void CMFCApplication2Dlg::OnBnClickedButton14()
{
  float tmp = middle_result;
  CalcSin(output, &outputlen, &middle_result, &if_middle_int, 1);
  //if_middle_valid = 1;
  if_last_result = 1;  
  sprintf(output, "%5f\0", middle_result);
  outputlen = strlen(output);
  //在editbox输出字符串
  CEdit* editbox;
  editbox = (CEdit*) GetDlgItem(IDC_EDIT1);
  int num = MultiByteToWideChar(0,0,output,-1,NULL,0);
  wchar_t *wide = new wchar_t[num];
  MultiByteToWideChar(0,0,output,-1,wide,num);
  editbox->SetWindowTextW(wide);
  middle_result = tmp;
}

//cos
void CMFCApplication2Dlg::OnBnClickedButton17()
{
  float tmp = middle_result;
  CalcSin(output, &outputlen, &middle_result, &if_middle_int, 2);
  //sin是单目运算，不改变中间结果
  //if_middle_valid = 1;
  if_last_result = 1;
  sprintf(output, "%5f\0", middle_result);
  outputlen = strlen(output);
  //在editbox输出字符串
  CEdit* editbox;
  editbox = (CEdit*) GetDlgItem(IDC_EDIT1);
  int num = MultiByteToWideChar(0,0,output,-1,NULL,0);
  wchar_t *wide = new wchar_t[num];
  MultiByteToWideChar(0,0,output,-1,wide,num);
  editbox->SetWindowTextW(wide);
  middle_result = tmp;
}


void CMFCApplication2Dlg::OnBnClickedButton20()
{
  
}

//+
void CMFCApplication2Dlg::OnBnClickedButton13()
{
  BasicCalc(output,&outputlen, &middle_result, &if_middle_int, 1, &if_middle_valid, &last_op, if_last_result);
  if_last_result = 1;
  int aaaa = (int)middle_result;
  if (fabs(middle_result - (int)middle_result) < 0.0001 || (fabs(middle_result - (int)middle_result) < 1 && fabs(middle_result - (int)middle_result) > 0.9999)) {
    sprintf(output, "%d\0", (int)middle_result);
  } else {
    sprintf(output, "%5f\0", middle_result);
  }  
  outputlen = strlen(output);
  //在editbox输出字符串
  CEdit* editbox;
  editbox = (CEdit*) GetDlgItem(IDC_EDIT1);
  int num = MultiByteToWideChar(0,0,output,-1,NULL,0);
  wchar_t *wide = new wchar_t[num];
  MultiByteToWideChar(0,0,output,-1,wide,num);
  editbox->SetWindowTextW(wide);
}

//-
void CMFCApplication2Dlg::OnBnClickedButton16()
{
  BasicCalc(output,&outputlen, &middle_result, &if_middle_int, 2, &if_middle_valid, &last_op, if_last_result);
  if_last_result = 1;
  if (fabs(middle_result - (int)middle_result) < 0.0001 || (fabs(middle_result - (int)middle_result) < 1 && fabs(middle_result - (int)middle_result) > 0.9999)) {
    sprintf(output, "%d\0", (int)middle_result);
  } else {
    sprintf(output, "%5f\0", middle_result);
  }  
  outputlen = strlen(output);
  //在editbox输出字符串
  CEdit* editbox;
  editbox = (CEdit*) GetDlgItem(IDC_EDIT1);
  int num = MultiByteToWideChar(0,0,output,-1,NULL,0);
  wchar_t *wide = new wchar_t[num];
  MultiByteToWideChar(0,0,output,-1,wide,num);
  editbox->SetWindowTextW(wide);
}

//*
void CMFCApplication2Dlg::OnBnClickedButton19()
{
  BasicCalc(output,&outputlen, &middle_result, &if_middle_int, 3, &if_middle_valid, &last_op, if_last_result);
  if_last_result = 1;
  if (fabs(middle_result - (int)middle_result) < 0.0001 || (fabs(middle_result - (int)middle_result) < 1 && fabs(middle_result - (int)middle_result) > 0.9999)) {
    sprintf(output, "%d\0", (int)middle_result);
  } else {
    sprintf(output, "%5f\0", middle_result);
  }  
  outputlen = strlen(output);
  //在editbox输出字符串
  CEdit* editbox;
  editbox = (CEdit*) GetDlgItem(IDC_EDIT1);
  int num = MultiByteToWideChar(0,0,output,-1,NULL,0);
  wchar_t *wide = new wchar_t[num];
  MultiByteToWideChar(0,0,output,-1,wide,num);
  editbox->SetWindowTextW(wide);
}

//  ÷
void CMFCApplication2Dlg::OnBnClickedButton22()
{
  BasicCalc(output,&outputlen, &middle_result, &if_middle_int, 4, &if_middle_valid, &last_op, if_last_result);
  if_last_result = 1;
  if (fabs(middle_result - (int)middle_result) < 0.0001 || (fabs(middle_result - (int)middle_result) < 1 && fabs(middle_result - (int)middle_result) > 0.9999)) {
    sprintf(output, "%d\0", (int)middle_result);
  } else {
    sprintf(output, "%5f\0", middle_result);
  }  
  outputlen = strlen(output);
  //在editbox输出字符串
  CEdit* editbox;
  editbox = (CEdit*) GetDlgItem(IDC_EDIT1);
  int num = MultiByteToWideChar(0,0,output,-1,NULL,0);
  wchar_t *wide = new wchar_t[num];
  MultiByteToWideChar(0,0,output,-1,wide,num);
  editbox->SetWindowTextW(wide);
}

//  =
void CMFCApplication2Dlg::OnBnClickedButton24()
{
  BasicCalc(output,&outputlen, &middle_result, &if_middle_int, 5, &if_middle_valid, &last_op, if_last_result);
  if_last_result = 1;
  if (fabs(middle_result - (int)middle_result) < 0.0001 || (fabs(middle_result - (int)middle_result) < 1 && fabs(middle_result - (int)middle_result) > 0.9999)) {
    sprintf(output, "%d\0", (int)middle_result);
  } else {
    sprintf(output, "%5f\0", middle_result);
  }  
  outputlen = strlen(output);
  //在editbox输出字符串
  CEdit* editbox;
  editbox = (CEdit*) GetDlgItem(IDC_EDIT1);
  int num = MultiByteToWideChar(0,0,output,-1,NULL,0);
  wchar_t *wide = new wchar_t[num];
  MultiByteToWideChar(0,0,output,-1,wide,num);
  editbox->SetWindowTextW(wide);
}

//  CE， 清除输入
void CMFCApplication2Dlg::OnBnClickedButton15()
{
  ClearInput(output, &outputlen);
  if_last_result = 0;
  //在editbox输出字符串
  CEdit* editbox;
  editbox = (CEdit*) GetDlgItem(IDC_EDIT1);
  int num = MultiByteToWideChar(0,0,output,-1,NULL,0);
  wchar_t *wide = new wchar_t[num];
  MultiByteToWideChar(0,0,output,-1,wide,num);
  editbox->SetWindowTextW(wide);
}

// C 清除所有
void CMFCApplication2Dlg::OnBnClickedButton25()
{
  ClearInput(output, &outputlen);
  if_middle_valid = 0;
  if_last_result = 0;
  //在editbox输出字符串
  CEdit* editbox;
  editbox = (CEdit*) GetDlgItem(IDC_EDIT1);
  int num = MultiByteToWideChar(0,0,output,-1,NULL,0);
  wchar_t *wide = new wchar_t[num];
  MultiByteToWideChar(0,0,output,-1,wide,num);
  editbox->SetWindowTextW(wide);
}
