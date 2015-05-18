<#import "/macro.ftl" as m>
<@m.page_header title="会员列表" css='seller_list_new|member_type_info' selected="member" subselected="list" js="member_list|My97DatePicker/WdatePicker|list_filter" />

<div class="rwrap">
	<div class="r_title"><span class="fl">会员列表</span>
	   <div class="search_wrap">
			<form action="${base}/member/merchant/list" class="search_form fl">
				<input type="text" name="key"  value="${(searcher.key)!}" 
									placeholder="会员名称/昵称" class="search_input">
				<button class="search_btn"></button>
			</form>
			<a href="javascript:" class="filter_a fl"></a>
			<a href="${base}/member/merchant/add" class="new_a fl ml12"></a>
		</div>
		<#if (searcher != null && searcher.hasParameter)! >
			<div class="search_result ofw">
				<p class="result_tit"><span class="result_tit_text">搜索/筛选</span>
					<div>
					<#if searcher.key><span class="b_tit" data-fid="1">名称/昵称：${(searcher.key)!}<b>x</b></span></#if>
					<#if searcher.mobile><span class="b_tit" data-fid="7">手机号：${(searcher.mobile)!}<b>x</b></span></#if>
					<#if (searcher.memberType.id)??><span class="b_tit" data-fid="2">会员类型:
						<#list memberTypes as memberType>
							<#if memberType.id == searcher.memberType.id>
								${(memberType.name)!}
							</#if>
						</#list>
						<b>x</b></span>
					</#if>
					<#if searcher.gender><span class="b_tit" data-fid="3">性别:<#if (searcher.gender=="male")!>男<#else>女</#if><b>x</b></span></#if>
					<#if (searcher.shop.id)??><span class="b_tit" data-fid="4">添加来源：
						 <#list fullShops as shop><#if searcher.shop.id == shop.id>${(shop.name)!}</#if></#list><b>x</b></span>
					</#if>
					<#if searcher.createStartDate><span class="b_tit" data-fid="5">起始创建时间：${(searcher.createStartDate?string('yyyy-MM-dd HH:mm:ss'))!}<b>x</b></span></#if>
					<#if searcher.createEndDate><span class="b_tit" data-fid="6">截止创建时间：${(searcher.createEndDate?string('yyyy-MM-dd HH:mm:ss'))!}<b>x</b></span></#if>
					</span>
					</div>
					<span class="w_tit">的结果</span></span>
				</p>
				<a href="${(base)!}/member/merchant/list" class="s_clear">清空</a>
			</div>
		</#if>
	</div>
		<table class="tb_main">
			<#if (!pager.list?? || pager.list?size==0) && ( searcher == null || !searcher.hasParameter)>
				<div class="new_hint_wrap"><div class="new_hint_bg"></div>您还没有会员，可以点击右上角<img src="${static_base}/css/img/admin_frame/new_a.png">按钮添加会员</div>
			<#else>
				<tr class="th">
					<td class="idl">编号</td>
					<td class="mer_name">会员名称</td>
					<td class="mer_name2">会员昵称</td>
					<td class="mer_type">会员类型</td>
					<td class="mer_tel">手机号码</td>
					<td class="mer_time">添加时间</td>
					<td class="mer_from">添加来源</td>
				</tr>
			</#if>
			
			<#list pager.list as member>
			<tr <#if member_index%2==0>class="tr_bg"</#if>>
				<td class="idl">${(member_index+1)!}</td>
				<td class="mer_name"><a href="${base}/member/${(member.eid)!}" class="b_a"><#if (member.name)?length == 0 >(空)<#else>${(member.name)!'(空)'}</#if></a></td>
				<td class="mer_name2">${(member.nickName)!'(空)'}</a></td>
				<td class="mer_type">${(member.memberType.name)!}</td>
				<td class="mer_tel">${(member.mobile)!}</td>
				<td class="mer_time">${(member.createDate?string('yyyy-MM-dd HH:mm'))!'-'}</td>
				<td class=" blue"><#if member.shop??>${(member.shop.name)!}</#if></td>
			</tr>
			</#list>
		</table>
		
		<div class="page_wrap">
			<@m.p page=pager.pageNumber totalpage=pager.pageCount />
		</div>
		<div class="pb pop_filter">
			<form action="${base}/member/merchant/list" method="get" class="f_form">
				<input type="hidden" name="key" value="<#if (searcher.key)?? >${searcher.key}</#if>" class="f_input fi_1"/>
				<div class="pb_title">筛选</div>
				<div class="pb_main">
					<div class="pb_item">
						<p class="pb_item_title">会员类型:</p>
						<select name="memberType.id" style="width: 201px;color:#000000;" class="f_input pb_item_input select_style fi_2"> 
							<option value="" >-会员类型-</option>
							<#list memberTypes as memberType>
								<option  value="${memberType.id}" 
									<#if memberType.id == (searcher.memberType.id)!0>selected =  "selected"</#if>
								>${(memberType.name)!}</option>
							</#list>
						</select>
					</div>
					<div class="pb_item">
						<p class="pb_item_title">性别：</p>
						<select name="gender" style="width: 201px;color:#000000;" class="f_input pb_item_input select_style fi_3">
							<option value="">-选择性别-</option>
							<option value="male" <#if (searcher.gender)!''=="male">selected="selected"</#if>>男</option>
							<option value="female"<#if (searcher.gender)!''=="female">selected="selected"</#if>>女</option>
						</select>
					</div>
					<div class="pb_item">
						<p class="pb_item_title">添加来源:</p>
						<select name="shop.id" style="width: 201px;color:#000000;" class="f_input pb_item_input select_style fi_4">
							<option value="" >--添加来源--</option>
							<#list fullShops as shop>
                                <#if (shop.name?length) <= 10>
                                    <option value="${(shop.id)!}" <#if (searcher.shop.id)?? && (searcher.shop.id == shop.id)>selected="selected" </#if> >${(shop.name)!} </option>
                                <#else >
                                    <option value="${(shop.id)!}" title="${(shop.name!)}" <#if (searcher.shop.id)?? && (searcher.shop.id == shop.id)>selected="selected" </#if> >${(shop.name)?substring(0,10)} </option>
                                </#if>
							</#list>
						</select>
					</div>
					<div class="pb_item">
						<p class="pb_item_title">手机号:</p>
						<input type="text" class="pb_item_input f_input fi_7" name="mobile"
											value="${(searcher.mobile)!}">
					</div>
					<div class="pb_item">
						<p class="pb_item_title">起始创建时间:</p>
						<input type="text" class="pb_item_input f_input fi_5" name="createStartDate"
											value="${(searcher.createStartDate?string('yyyy-MM-dd HH:mm:ss'))!}" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})">
					</div>
					<div class="pb_item">
						<p class="pb_item_title">截止创建时间:</p>
						<input type="text" class="pb_item_input f_input fi_6" name="createEndDate"
											value="${(searcher.createEndDate?string('yyyy-MM-dd HH:mm:ss'))!}" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})">
					</div>
				</div>
				<button type="submit" class="pb_btn pb_btn_s">确定</button>
			    <span class="pb_btn_split">或</span><a href="javascript:" class="pb_cancel_a">取消</a>
			</form>
		</div>
	<#if (status == "faild")!>
		<div class="pop_hint pop_hint3">${(msg)!}</div>
	</#if>
	<#if (status == "success")!>
		<div class="pop_hint pop_hint2">${(msg)!}</div>
	</#if>
	</div>
<@m.page_footer />

