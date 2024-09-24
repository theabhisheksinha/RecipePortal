#region XD World Recipe V 3
// FileName: ProviderNewestCalendar.cs
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
    /// object in this class manages newst recipe side menu object List collection
    /// </summary>
    public static class NewestCalendarMenuProvider
    {
        /// <summary>
        /// Return Newest Recipe Side Panel
        /// </summary>
        public static ExtendedCollection<Calendar> GetCalendar(int Top)
        {
            ExtendedCollection<Calendar> list = new ExtendedCollection<Calendar>();

            string Key = "Newest_Calendars";

            if (Caching.Cache[Key] != null)
            {
                list = (ExtendedCollection<Calendar>)Caching.Cache[Key];
            }
            else
            {
                IDataReader dr = Blogic.ActionProcedureDataProvider.GetNewestCalendarSidePanel(Top);

                while (dr.Read())
                {
                    Calendar item = new Calendar();

                    item.ID = (int)dr["ID"];

                    if (dr["Title"] != DBNull.Value)
                    {
                        item.Title = (string)dr["Title"];
                    }
                    if (dr["CAT_NAME"] != DBNull.Value)
                    {
                        item.Category = (string)dr["CAT_NAME"];
                    }
                    if (dr["Post_Date"] != DBNull.Value)
                    {
                        item.Date = (DateTime)(dr["Post_Date"]);
                    }
                    if (dr["HITS"] != DBNull.Value)
                    {
                        item.Hits = (int)dr["HITS"];
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
