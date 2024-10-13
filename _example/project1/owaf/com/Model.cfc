component extends="owaf3.com.Model"	{

	public numeric function getLeadingNumberByCompany(required string num = 0, numeric ln = 3)	{

		var tbl = this.getTableAlias()

		if(arguments.num == 0)	{
			arguments.num = val(this.Max('#tbl#.Number','#tbl#.CompanyId=#request.user.companyid#'))+1
		}

		rt = arguments.num
		loop from="1" to="#arguments.ln - len(arguments.num)#" index="i"	{
			rt = "0" & rt
		}
		/*switch(arguments.ln - len(arguments.num)){
			case 1:
				rt = "0" & arguments.num
			break;
			case 2:
				rt = "00" & arguments.num
			break;
			case 3:
				rt = "000" & arguments.num
			break;
			case 4:
				rt = "0000" & arguments.num
			break;
			default:
				rt = arguments.num
			break;
		}*/
		return rt
	}

	public string function getLeadingNumber(string num, numeric ln = 3, boolean addone = false, boolean cast = false)	{

		var tbl = this.getTableAlias()

		if(arguments.num == "" || arguments.num == 0)	{
			arguments.num = this.Max(field: '#tbl#.Number', cast : arguments.cast)
			if(arguments.addone)	{
				arguments.num = val(arguments.num) + 1
			}
			num_len = len(arguments.num)
			j=0
			loop from="1" to="#num_len#" index="i"	{
				j++
				if(mid(arguments.num,i,1))	{
					break;
				}
			}

			if(len(arguments.num) > arguments.ln)	{
				arguments.num = left(arguments.num, j) & val(right(arguments.num, num_len-j))+1
			}

		}

		rt = arguments.num
		loop from="1" to="#arguments.ln - len(arguments.num)#" index="i"	{
			rt = "0" & rt
		}

		return rt
	}

	include "inc_model.cfm";
	include "inc_other_func.cfm";

}