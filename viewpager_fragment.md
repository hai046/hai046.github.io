# ViewPager Fragment  FIX


Err Log：

    1，make sure class name exists, is public, 
    and has an empty constructor that is public at
    android.support.v4.app.Fragment.instantiate
    
解决办法：
    
    在页面里面  继承DesFragment 添加匿名内部类即可 
    伪代码如下
        
        public static class XXXFragment extends DesFragment {

        public XXXFragment() {

        }

        public static FragmentRegisterSchool getInstance(T bundle) {
            XXXFragment fragment = new XXXFragment();
            fragment.setXXX(bundle);
            return fragment;
        }
        }