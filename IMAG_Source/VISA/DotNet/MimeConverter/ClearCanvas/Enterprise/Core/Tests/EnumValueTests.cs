#region License

// Copyright (c) 2013, ClearCanvas Inc.
// All rights reserved.
// http://www.clearcanvas.ca
//
// This file is part of the ClearCanvas RIS/PACS open source project.
//
// The ClearCanvas RIS/PACS open source project is free software: you can
// redistribute it and/or modify it under the terms of the GNU General Public
// License as published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
//
// The ClearCanvas RIS/PACS open source project is distributed in the hope that it
// will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General
// Public License for more details.
//
// You should have received a copy of the GNU General Public License along with
// the ClearCanvas RIS/PACS open source project.  If not, see
// <http://www.gnu.org/licenses/>.

#endregion

#if UNIT_TESTS

#pragma warning disable 1591

using NUnit.Framework;

namespace ClearCanvas.Enterprise.Core.Tests
{
	[TestFixture]
	public class EnumValueTests
	{
		public class ConcreteEnumValue : EnumValue
		{
			/// <summary>
			/// Constructor required for dynamic proxy.
			/// </summary>
			public ConcreteEnumValue()
			{
			}

			public ConcreteEnumValue(string code)
				:base(code, null, null)
			{
			}
		}

		public class ConcreteEnumValue2 : EnumValue
		{
			/// <summary>
			/// Constructor required for dynamic proxy.
			/// </summary>
			public ConcreteEnumValue2()
			{
			}

			public ConcreteEnumValue2(string code)
				: base(code, null, null)
			{
			}
		}


		[Test]
		public void Test_CreateProxy()
		{
			var raw = new ConcreteEnumValue("a");
			var proxy = EntityProxyFactory.CreateProxy(raw);

			// the proxy and raw instance are not the same
			Assert.IsFalse(ReferenceEquals(raw, proxy));
		}

		[Test]
		public void Test_GetClass_returns_type_of_raw_instance()
		{
			var raw = new ConcreteEnumValue("a");
			var proxy = EntityProxyFactory.CreateProxy(raw);

			// the type of the proxy is not the type of the raw instance
			Assert.AreNotEqual(typeof(ConcreteEnumValue), proxy.GetType());
			
			// the GetClass method returns the type of the raw instance
			Assert.AreEqual(typeof(ConcreteEnumValue), proxy.GetClass());
		}

		[Test]
		public void Test_Equals_correctly_compares_proxy_and_raw_instances()
		{
			var raw = new ConcreteEnumValue("a");
			var proxy = EntityProxyFactory.CreateProxy(raw);

			// the proxy and raw instance are not the same
			Assert.IsFalse(ReferenceEquals(raw, proxy));

			// check every possible permutation
			Assert.IsTrue(raw.Equals(raw));
			Assert.IsTrue(proxy.Equals(proxy));
			Assert.IsTrue(raw.Equals(proxy));
			Assert.IsTrue(proxy.Equals(raw));
		}

		[Test]
		public void Test_GetHashCode_identical_between_proxy_and_raw_instances()
		{
			var raw = new ConcreteEnumValue("a");
			var proxy = EntityProxyFactory.CreateProxy(raw);

			// the proxy and raw instance are not the same
			Assert.IsFalse(ReferenceEquals(raw, proxy));

			var x = raw.GetHashCode();
			var y = proxy.GetHashCode();

			// hash codes are same
			Assert.AreEqual(x, y);
		}

		[Test]
		public void Test_Equals_fails_for_same_code_different_class()
		{
			var a1 = new ConcreteEnumValue("a");
			var a2 = new ConcreteEnumValue2("a");

			Assert.AreNotEqual(a1, a2);
		}
	}
}

#endif
