<#import "/macro.ftl" as m>
<@m.page_header selected='coupon' subselected="couponInfoList" css="seller_info|coupon_detail" js="coupon_detail" title="优惠统计"/>
<SCRIPT>
var CONTEXT = '${base}',
	CONT_DETAIL = ''
</SCRIPT>
<div class="rwrap">
	<p class="r_title"><a class="back_a" href="${base}/coupon/detail/${(couponInfo.eid)}"></a>电子券统计</p>
	<div class="tb_wrap" style="border-top:1px solid #EBEBEB;margin-top:14px;">
		<div class="tb_title">基本信息</div>
		<table class="tb_main">
			<tr>
				<td><span class="td_key">创建时间</span><span class="td_val">${(couponInfo.createDate?string('yyyy/MM/dd HH:mm:dd'))!}</span></td>
				<td><span class="td_key">电子券编号</span><span class="td_val coupon_id">${(couponInfo.eid)!}</span></td>
			</tr>
			<tr class="tr_bg">
				<td><span class="td_key">名称</span><span class="td_val">${(couponInfo.name)!}</span></td>
				
				<td><span class="td_key">适用商户</span><span class="td_val">${(shopList[0].name)!}</span></td>
			</tr>
			<tr>
				<td colspan='2'><span class="td_key">简介</span><span class="td_val">${(couponInfo.intro)!}</span></td>
			</tr>
		</table>
	</div>
	<div class="tb_wrap tb_other">
		<div class="tb_title">优惠码列表
			<span>总数:<#if !(couponInfo.limitCount)?? || couponInfo.limitCount lte 0>不限<#else>${couponInfo.limitCount}</#if></span>
			<span>已发放:${couponInfo.received}</span>
			<span class="stwrap">
				<input type="checkbox" name="status" value="USED" class="stcb" id="stcb1" <#if status?? && status?contains("USED")>checked=true</#if>/><label class="stlb" for="stcb1">已使用(${(usedCouponCount)!})</label>
				<input type="checkbox" name="status" value="AVAILABLE" class="stcb" id="stcb2" <#if status?? && status?contains("AVAILABLE")>checked=true</#if>/><label class="stlb" for="stcb2">未使用(${(availableCouponCount)!})</label>
				<input type="checkbox" name="status" value="EXPIRED" class="stcb" id="stcb3" <#if status?? && status?contains("EXPIRED")>checked=true</#if>/><label class="stlb" for="stcb3">已过期(${(expiredCouponCount)!})</label>
				<input type="checkbox" name="status" value="REFUND_APPLY,REFUND_ACCEPTED,REFUND_SUCCESS,REFUND_FAIL" class="stcb" id="stcb4" <#if status?? && status?contains("REFUND")>checked=true</#if>/><label class="stlb" for="stcb4">已退款(${(refundCouponCount)!})</label>
			</span>
		</div>
		<table class="tb_main">
			<tr class="th">
				<td>获取时间</td>
				<td class="name">用户姓名</td>
				<td>手机号码</td>
				<td>优惠码</td>
				<td class="state">使用状态</td>
				<td>使用时间</td>
				<td>操作员</td>
			</tr>
			<#list pager.list as coupon>
			<tr <#if coupon_index%2==0>class="tr_bg"</#if>>
				<td>${(coupon.createDate?string('yyyy/MM/dd HH:mm:ss'))!}</td>
				<td class="name">${(coupon.member.name)!}</td>
				<td><@mobileHid  coupon.mobile!'' /></td>
				<td><@couponCodeHid  coupon.couponCode /></td>
				<td class="state">
					<#if coupon.status == 'USED'>
						<span class="state1">已使用</span>
					<#elseif coupon.status = 'AVAILABLE'>
						<span class="state2">未使用</span>
					<#elseif coupon.status = 'EXPIRED'>
						<span class="state3">已过期</span>
					<#elseif coupon.status = 'REFUND_APPLY' || coupon.status = 'REFUND_ACCEPTED'|| coupon.status = 'REFUND_SUCCESS'|| coupon.status = 'REFUND_FAIL'>
						<span class="state4">已退款</span>
					</#if>
				</td>
				<td><#if coupon.status == 'USED'>${coupon.consumeDate?string('yyyy/MM/dd HH:mm:ss')}<#else>-</#if></td>
				<td><#if coupon.status == 'USED'>${(coupon.operator.realName)!}</#if></td>
			</tr>
			</#list>
		</table>
		<div class="page_wrap">
			<@m.p page=pager.pageNumber totalpage=pager.pageCount />
		</div>
	</div>
</div>
<@m.page_footer />

<#macro mobileHid mobile>
	<#if mobile?length gte 10>
	   ${mobile[0..2]}****${mobile[7..10]}
	<#else>
	   ${mobile}
	</#if>
</#macro>

<#macro couponCodeHid couponCode>
	<#if couponCode?length gte 9>
	   ${couponCode[0..1]}*****${couponCode[8..9]}
	<#else>
	   ${couponCode}
	</#if>
</#macro>