#  IMT iOS convention
## 1. If the class handle data, It should inherit BaseDataViewController
## 2. The controller only creates viewModel
## 3. The viewModel is handler. It handles logic for the feature. You need to use a variable ObserverObject to reload the UI when the data changes. Example: call API, alogithirm
## 4. When you define color, string, image,... You must define in Extension. Refer extensions: ColorExtension, ImageExtension, StringExtensions
## 5. Naming convention:
### - Acronym for a UI variable: 
        Lable -> lb, lbl
        Button -> btn, 
        TextFeild -> tf, 
        TextView -> tv
        UIView -> v, 
        TableView -> tbv, 
        CollectionView -> clv
        DropDown -> dd
### - Acronum for Action:
        action logint -> actionLogin
        
# --- Build app IMT iOS --
Step 1: Open xcode 
Step 2: Choosing scheme (IMT-iOS(Develop), IMT-iOS(Stagging) or IMT-iOS(Rroduct))
Step 3: Shortcut key Command + R

###Note: You can change the environment variables in file .xcconfig
    
    
