#region XD World Recipe V 3
// FileName: ProviderCalendarCategory.cs
// Author: Dexter Zafra
// Date Created: 8/19/2008
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
    /// object in this class manages recipe category object List collection
    /// </summary>
    public sealed class CalendarCategoryProvider : Calendar
    {
        private static readonly CalendarCategoryProvider Instance = new CalendarCategoryProvider();
 
        static CalendarCategoryProvider() 
        {
        }

        CalendarCategoryProvider() 
        { 
        }

        public static CalendarCategoryProvider GetInstance()
        {
          return Instance;
        }

        public void CalendarCategoryParam(int CatId, int OrderBy, int SortBy, int PageIndex, int PageSize)
        {
            this._CatID = CatId;
            this._OrderBy = OrderBy;
            this._SortBy = SortBy;
            this._Index = PageIndex;
            this._PageSize = PageSize;

            IDataReader dr = GetData;

            while (dr.Read())
            {
                this._Category = (string)dr["CAT_NAME"];
                this._RecordCount = (int)dr["RCount"];
            }

            dr.Close();
        }

        /// <summary>
        /// Return Recipe Category Data
        /// </summary>
        private IDataReader GetData
        {
            get
            {
                //Get data
                IDataReader dr = Blogic.ActionProcedureDataProvider.GetCalendarsInCategory(CatID, OrderBy, SortBy, Index, PageSize);
                return dr;
            }
        }

        public ExtendedCollection<Calendar> GetCategories()
        {
            ExtendedCollection<Calendar> list = new ExtendedCollection<Calendar>();

            IDataReader dr = GetData;

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
                if (dr["Author"] != DBNull.Value)
                {
                    item.Author = (string)dr["Author"];
                }
                if (dr["Summary"] != DBNull.Value)
                {
                    item.Summary = (string)dr["Summary"];
                }
                if (dr["Rates"] != DBNull.Value)
                {
                    item.Rating = dr["Rates"].ToString();
                }
                if (dr["No_Rates"] != DBNull.Value)
                {
                    item.NoRates = dr["No_Rates"].ToString();
                }
                if (dr["Post_Date"] != DBNull.Value)
                {
                    item.Date = (DateTime)(dr["Post_Date"]);
                }
                if (dr["HITS"] != DBNull.Value)
                {
                    item.Hits = (int)dr["HITS"];
                }
                if (dr["UID"] != DBNull.Value)
                {
                    item.UID = (int)dr["UID"];
                }

                list.Add(item);
            }

            dr.Close();

            return list;
        }
    }
}
