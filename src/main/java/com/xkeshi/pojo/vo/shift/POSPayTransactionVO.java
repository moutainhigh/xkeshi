package com.xkeshi.pojo.vo.shift;

import java.math.BigDecimal;

public class POSPayTransactionVO {

	/*支付总金额*/
	private BigDecimal  totalAmount ;

	public POSPayTransactionVO() {
		super();
	}

	public POSPayTransactionVO(BigDecimal totalAmount) {
		super();
		this.totalAmount = totalAmount;
	}

	public BigDecimal getTotalAmount() {
		if (totalAmount != null) {
			return totalAmount.setScale(2,BigDecimal.ROUND_DOWN);
		}
		return totalAmount;
	}

	public void setTotalAmount(BigDecimal totalAmount) {
		this.totalAmount = totalAmount;
	}
}
