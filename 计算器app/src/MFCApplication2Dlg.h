
// MFCApplication2Dlg.h: 头文件
//

#pragma once


// CMFCApplication2Dlg 对话框
class CMFCApplication2Dlg : public CDialogEx
{
// 构造
public:
	CMFCApplication2Dlg(CWnd* pParent = nullptr);	// 标准构造函数

// 对话框数据
#ifdef AFX_DESIGN_TIME
	enum { IDD = IDD_MFCAPPLICATION2_DIALOG };
#endif

	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV 支持


// 实现
protected:
	HICON m_hIcon;

	// 生成的消息映射函数
	virtual BOOL OnInitDialog();
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	DECLARE_MESSAGE_MAP()
public:
  afx_msg void OnBnClickedButton1();
  afx_msg void OnEnChangeEdit1();
  afx_msg void OnBnClickedButton2();
  afx_msg void OnBnClickedButton3();
  afx_msg void OnBnClickedButton4();
  afx_msg void OnBnClickedButton5();
  afx_msg void OnBnClickedButton6();
  afx_msg void OnBnClickedButton7();
  afx_msg void OnBnClickedButton8();
  afx_msg void OnBnClickedButton9();
  afx_msg void OnBnClickedButton11();
  afx_msg void OnBnClickedButton12();
  afx_msg void OnBnClickedButton14();
  afx_msg void OnBnClickedButton17();
  afx_msg void OnBnClickedButton20();
  afx_msg void OnBnClickedButton13();
  afx_msg void OnBnClickedButton16();
  afx_msg void OnBnClickedButton19();
  afx_msg void OnBnClickedButton22();
  afx_msg void OnBnClickedButton24();
  afx_msg void OnBnClickedButton15();
  afx_msg void OnBnClickedButton25();
};
