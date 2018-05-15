/*
 Copyright 2010-2016 Amazon.com, Inc. or its affiliates. All Rights Reserved.

 Licensed under the Apache License, Version 2.0 (the "License").
 You may not use this file except in compliance with the License.
 A copy of the License is located at

 http://aws.amazon.com/apache2.0

 or in the "license" file accompanying this file. This file is distributed
 on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
 express or implied. See the License for the specific language governing
 permissions and limitations under the License.
 */
 

import Foundation
import AWSCore

 @objcMembers
public class REVCIPSSERevenueResponseModel_Items_item_Revenue_month_item : AWSModel {
    
    var date: String?
    var actuals: REVCIPSSERevenueResponseModel_Items_item_Revenue_month_item_actuals?
    var monthVsPlan: REVCIPSSERevenueResponseModel_Items_item_Revenue_month_item_monthVsPlan?
    var ytdVsPlan: REVCIPSSERevenueResponseModel_Items_item_Revenue_month_item_ytdVsPlan?
    
   	public override static func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]!{
		var params:[AnyHashable : Any] = [:]
		params["date"] = "date"
		params["actuals"] = "actuals"
		params["monthVsPlan"] = "monthVsPlan"
		params["ytdVsPlan"] = "ytdVsPlan"
		
        return params
	}
	class func actualsJSONTransformer() -> ValueTransformer{
	    return ValueTransformer.awsmtl_JSONDictionaryTransformer(withModelClass: REVCIPSSERevenueResponseModel_Items_item_Revenue_month_item_actuals.self);
	}
	class func monthVsPlanJSONTransformer() -> ValueTransformer{
	    return ValueTransformer.awsmtl_JSONDictionaryTransformer(withModelClass: REVCIPSSERevenueResponseModel_Items_item_Revenue_month_item_monthVsPlan.self);
	}
	class func ytdVsPlanJSONTransformer() -> ValueTransformer{
	    return ValueTransformer.awsmtl_JSONDictionaryTransformer(withModelClass: REVCIPSSERevenueResponseModel_Items_item_Revenue_month_item_ytdVsPlan.self);
	}
}
