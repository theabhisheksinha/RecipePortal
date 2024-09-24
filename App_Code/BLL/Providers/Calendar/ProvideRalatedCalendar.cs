#region XD World Recipe V 3
// FileName: ProviderRalatedCalendar.cs
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
    /// object in this class manages related Calendar object List collection
    /// </summary>
    public sealed class ProviderRalatedCalendar : Calendar
    {
        public static readonly ProviderRalatedCalendar Instance = new ProviderRalatedCalendar();

        static ProviderRalatedCalendar()
        {
        }

        ProviderRalatedCalendar()
        {
        }

        public static ProviderRalatedCalendar GetInstance()
        {
            return Instance;
        }

        public void Param(int CatID, int AID)
        {
            this._CatID = CatID;
            this._ID = AID;

            IDataReader dr = GetData;

            while (dr.Read())
            {
                this._RecordCount = (int)dr["TotalCount"];
            }

            dr.Close();
        }

        /// <summary>
        /// Return Data
        /// </summary>
        /// <returns></returns>
        public IDataReader GetData
        {
            get
            {
                //Get data
                IDataReader dr = Blogic.ActionProcedureDataProvider.GetRelatedCalendar(CatID, ID);
                return dr;
            }
        }

        public ExtendedCollection<Calendar> GetCalendar()
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
                if (dr["HITS"] != DBNull.Value)
                {
                    item.Hits = (int)dr["HITS"];
                }

                list.Add(item);
            }

            dr.Close();

            return list;
        }
    }
}

