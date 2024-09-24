#region XD World Recipe V 3
// FileName: ProviderLast5CalendarPublishedByUser.cs
// Author: Dexter Zafra
// Date Created: 8/22/2008
// Website: www.ex-designz.net
#endregion
using System;
using System.Data;
using XDRecipe.BL;
using XDRecipe.Common;
using XDRecipe.Model;

namespace XDRecipe.BL.Providers.Calendar
{
    /// <summary>
    /// object in this class returns a list of the last 5 published Calendar by user.
    /// </summary>
    public sealed class ProviderLast5CalendarPublishedByUser : Calendar
    {
        private static readonly ProviderLast5CalendarPublishedByUser Instance = new ProviderLast5CalendarPublishedByUser();

        static ProviderLast5CalendarPublishedByUser()
        {
        }

        ProviderLast5CalendarPublishedByUser()
        {
        }

        public static ProviderLast5CalendarPublishedByUser GetInstance()
        {
            return Instance;
        }

        public void Param(int UserID)
        {
            this._UID = UserID;
        }

        /// <summary>
        /// Return Data
        /// </summary>
        /// <returns></returns>
        private IDataReader GetData
        {
            get
            {
                //Get data
                IDataReader dr = Blogic.ActionProcedureDataProvider.GetLast5CalendarByUser(UID);
                return dr;
            }
        }

        public ExtendedCollection<Calendar> GetCalendar()
        {
             ExtendedCollection<Calendar> list = new ExtendedCollection<Calendar>();

             string Key = "Last5_CalendarPublishedByUser_" + UID;

             if (Caching.Cache[Key] != null)
             {
                 list = (ExtendedCollection<Calendar>)Caching.Cache[Key];
             }
             else
             {

                 IDataReader dr = GetData;

                 while (dr.Read())
                 {
                     Calendar item = new Calendar();

                     item.ID = (int)dr["ID"];

                     if (dr["Title"] != DBNull.Value)
                     {
                         item.Title = (string)dr["Title"];
                     }
                     if (dr["ShortTitle"] != DBNull.Value)
                     {
                         item.ShortTitle = (string)dr["ShortTitle"];
                     }
                     if (dr["CAT_NAME"] != DBNull.Value)
                     {
                         item.Category = (string)dr["CAT_NAME"];
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
