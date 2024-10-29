using System;

namespace Hydra.IX.Common
{
    public static class EnumUtil<T> where T : struct, IConvertible
    {
        public static T ParseDefined(string enumValue)
        {
            var parsedValue = (T)System.Enum.Parse(typeof(T), enumValue);

            if (!System.Enum.IsDefined(typeof(T), parsedValue))
                throw new ArgumentException(string.Format("{0} is not a defined value for enum type {1}",
                enumValue, typeof(T).FullName));

            return parsedValue;
        }

        public static T Parse(string enumValue, T defaultValue)
        {
            var parsedValue = (T)System.Enum.Parse(typeof(T), enumValue);

            return System.Enum.IsDefined(typeof(T), parsedValue) ? parsedValue : defaultValue;
        }
    }
}