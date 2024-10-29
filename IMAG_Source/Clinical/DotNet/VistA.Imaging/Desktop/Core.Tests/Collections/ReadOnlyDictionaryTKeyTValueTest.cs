// <copyright file="ReadOnlyDictionaryTKeyTValueTest.cs" company="Department of Veterans Affairs">Copyright © Department of Veterans Affairs 2011</copyright>
namespace VistA.Imaging.Collections
{
    using System;
    using System.Collections.Generic;
    using Microsoft.Pex.Framework;
    using Microsoft.Pex.Framework.Validation;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using VistA.Imaging.Collections;

    /// <summary>This class contains parameterized unit tests for ReadOnlyDictionary`2</summary>
    [PexClass(typeof(ReadOnlyDictionary<,>))]
    [PexAllowedExceptionFromTypeUnderTest(typeof(InvalidOperationException))]
    [PexAllowedExceptionFromTypeUnderTest(typeof(ArgumentException), AcceptExceptionSubtypes = true)]
    [PexAllowedExceptionFromTypeUnderTest(typeof(NotSupportedException))]
    [PexAllowedException(typeof(KeyNotFoundException))]
    [TestClass]
    public partial class ReadOnlyDictionaryTKeyTValueTest
    {
        /// <summary>Test stub for Add(!0, !1)</summary>
        [PexGenericArguments(typeof(int), typeof(int))]
        [PexMethod]
        public void Add<TKey, TValue>(
            [PexAssumeUnderTest]ReadOnlyDictionary<TKey, TValue> target,
            TKey key,
            TValue value)
        {
            target.Add(key, value);
        }

        /// <summary>Test stub for Add(KeyValuePair`2&lt;!0,!1&gt;)</summary>
        [PexGenericArguments(typeof(int), typeof(int))]
        [PexMethod]
        public void Add01<TKey, TValue>(
            [PexAssumeUnderTest]ReadOnlyDictionary<TKey, TValue> target,
            KeyValuePair<TKey, TValue> item)
        {
            target.Add(item);
        }

        /// <summary>Test stub for Clear()</summary>
        [PexGenericArguments(typeof(int), typeof(int))]
        [PexMethod]
        public void Clear<TKey, TValue>([PexAssumeUnderTest]ReadOnlyDictionary<TKey, TValue> target)
        {
            target.Clear();
        }

        /// <summary>Test stub for .ctor()</summary>
        [PexGenericArguments(typeof(int), typeof(int))]
        [PexMethod]
        public ReadOnlyDictionary<TKey, TValue> Constructor<TKey, TValue>()
        {
            ReadOnlyDictionary<TKey, TValue> target = new ReadOnlyDictionary<TKey, TValue>();
            return target;
        }

        /// <summary>Test stub for .ctor(IDictionary`2&lt;!0,!1&gt;)</summary>
        [PexGenericArguments(typeof(int), typeof(int))]
        [PexMethod]
        public ReadOnlyDictionary<TKey, TValue> Constructor01<TKey, TValue>(IDictionary<TKey, TValue> dictionary)
        {
            ReadOnlyDictionary<TKey, TValue> target
               = new ReadOnlyDictionary<TKey, TValue>(dictionary);
            return target;
        }

        /// <summary>Test stub for Contains(KeyValuePair`2&lt;!0,!1&gt;)</summary>
        [PexGenericArguments(typeof(int), typeof(int))]
        [PexMethod]
        public bool Contains<TKey, TValue>(
            [PexAssumeUnderTest]ReadOnlyDictionary<TKey, TValue> target,
            KeyValuePair<TKey, TValue> item)
        {
            bool result = target.Contains(item);
            return result;
        }

        /// <summary>Test stub for ContainsKey(!0)</summary>
        [PexGenericArguments(typeof(int), typeof(int))]
        [PexMethod]
        public bool ContainsKey<TKey, TValue>(
            [PexAssumeUnderTest]ReadOnlyDictionary<TKey, TValue> target,
            TKey key)
        {
            bool result = target.ContainsKey(key);
            return result;
        }

        /// <summary>Test stub for CopyTo(KeyValuePair`2&lt;!0,!1&gt;[], Int32)</summary>
        [PexGenericArguments(typeof(int), typeof(int))]
        [PexMethod]
        public void CopyTo<TKey, TValue>(
            [PexAssumeUnderTest]ReadOnlyDictionary<TKey, TValue> target,
            KeyValuePair<TKey, TValue>[] array,
            int arrayIndex)
        {
            target.CopyTo(array, arrayIndex);
        }

        /// <summary>Test stub for get_Count()</summary>
        [PexGenericArguments(typeof(int), typeof(int))]
        [PexMethod]
        public int CountGet<TKey, TValue>([PexAssumeUnderTest]ReadOnlyDictionary<TKey, TValue> target)
        {
            int result = target.Count;
            return result;
        }

        /// <summary>Test stub for GetEnumerator()</summary>
        [PexGenericArguments(typeof(int), typeof(int))]
        [PexMethod]
        public IEnumerator<KeyValuePair<TKey, TValue>> GetEnumerator<TKey, TValue>([PexAssumeUnderTest]ReadOnlyDictionary<TKey, TValue> target)
        {
            IEnumerator<KeyValuePair<TKey, TValue>> result = target.GetEnumerator();
            return result;
        }

        /// <summary>Test stub for get_IsReadOnly()</summary>
        [PexGenericArguments(typeof(int), typeof(int))]
        [PexMethod]
        public bool IsReadOnlyGet<TKey, TValue>([PexAssumeUnderTest]ReadOnlyDictionary<TKey, TValue> target)
        {
            bool result = target.IsReadOnly;
            return result;
        }

        /// <summary>Test stub for get_Item(!0)</summary>
        [PexGenericArguments(typeof(int), typeof(int))]
        [PexMethod]
        public TValue ItemGet<TKey, TValue>(
            [PexAssumeUnderTest]ReadOnlyDictionary<TKey, TValue> target,
            TKey key)
        {
            TValue result = target[key];
            return result;
        }

        /// <summary>Test stub for set_Item(!0, !1)</summary>
        [PexGenericArguments(typeof(int), typeof(int))]
        [PexMethod]
        public void ItemSet<TKey, TValue>(
            [PexAssumeUnderTest]ReadOnlyDictionary<TKey, TValue> target,
            TKey key,
            TValue value)
        {
            target[key] = value;
        }

        /// <summary>Test stub for get_Keys()</summary>
        [PexGenericArguments(typeof(int), typeof(int))]
        [PexMethod]
        public ICollection<TKey> KeysGet<TKey, TValue>([PexAssumeUnderTest]ReadOnlyDictionary<TKey, TValue> target)
        {
            ICollection<TKey> result = target.Keys;
            return result;
        }

        /// <summary>Test stub for Remove(!0)</summary>
        [PexGenericArguments(typeof(int), typeof(int))]
        [PexMethod]
        public bool Remove<TKey, TValue>(
            [PexAssumeUnderTest]ReadOnlyDictionary<TKey, TValue> target,
            TKey key)
        {
            bool result = target.Remove(key);
            return result;
        }

        /// <summary>Test stub for Remove(KeyValuePair`2&lt;!0,!1&gt;)</summary>
        [PexGenericArguments(typeof(int), typeof(int))]
        [PexMethod]
        public bool Remove01<TKey, TValue>(
            [PexAssumeUnderTest]ReadOnlyDictionary<TKey, TValue> target,
            KeyValuePair<TKey, TValue> item)
        {
            bool result = target.Remove(item);
            return result;
        }

        /// <summary>Test stub for TryGetValue(!0, !1&amp;)</summary>
        [PexGenericArguments(typeof(int), typeof(int))]
        [PexMethod]
        public bool TryGetValue<TKey, TValue>(
            [PexAssumeUnderTest]ReadOnlyDictionary<TKey, TValue> target,
            TKey key,
            out TValue value)
        {
            bool result = target.TryGetValue(key, out value);
            return result;
        }

        /// <summary>Test stub for get_Values()</summary>
        [PexGenericArguments(typeof(int), typeof(int))]
        [PexMethod]
        public ICollection<TValue> ValuesGet<TKey, TValue>([PexAssumeUnderTest]ReadOnlyDictionary<TKey, TValue> target)
        {
            ICollection<TValue> result = target.Values;
            return result;
        }
    }
}
