#region XD World Recipe V 3
// FileName: ProviderCalendarCategorySideMenu.cs
// Author: Dexter Zafra
// Date Created: 8/26/2008
// Website: www.ex-designz.net
#endregion
using System;
using System.Web;
using System.Data;
using XDRecipe.BL;
using XDRecipe.Common;
using XDRecipe.Model;

namespace XDRecipe.BL.Providers.Calendar
{
    /// <summary>
    /// object in this class manages Calendar category side menu object List collection
    /// </summary>
    public static class CalendarCategoryMenuProvider
    {
        /// <summary>
        /// Return Calendar Category
        /// </summary>
        public static ExtendedCollection<Calendar> GetCalendar()
        {
            ExtendedCollection<Calendar> list = new ExtendedCollection<Calendar>();

            string Key = "CalendarCategory_SideMenu";

            if (Caching.Cache[Key] != null)
            {
                list = (ExtendedCollection<Calendar>)Caching.Cache[Key];
            }
            else
            {
                IDataReader dr = Blogic.ActionProcedureDataProvider.GetCalendarCategoryList;

                while (dr.Read())
                {
                    Calendar item = new Calendar();

                    item.CatID = (int)dr["CAT_ID"];

                    if (dr["CAT_NAME"] != DBNull.Value)
                    {
                        item.Category = (string)dr["CAT_NAME"];
                    }
                    if (dr["REC_COUNT"] != DBNull.Value)
                    {
                        item.RecordCount = (int)(dr["REC_COUNT"]);
                    }

                    list.Add(item);

                    Caching.CahceData(Key, list);
                }

                dr.Close();
            }

            return list;
        }
    }
}
