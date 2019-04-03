//
//  Labels.swift
//  Watcher
//
//  Created by Петр Первухин on 20/03/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import UIKit

final class H1Label: UILabel {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.textColor = ColorThemeManager.shared.current.mainTextColor
        self.font = UIFont.h1Font
    }
}

final class B2Label: UILabel {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.textColor = ColorThemeManager.shared.current.mainTextColor
        self.font = UIFont.b2Font
    }
}

final class T1Label: UILabel {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.textColor = ColorThemeManager.shared.current.mainTextColor
        self.font = UIFont.t1Font
    }
}

final class T2Label: UILabel {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.textColor = ColorThemeManager.shared.current.mainTextColor
        self.font = UIFont.t2Font
    }
}

final class B1Label: UILabel {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.textColor = ColorThemeManager.shared.current.mainTextColor
        self.font = UIFont.b1Font
    }
}

final class B3Label: UILabel {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.textColor = ColorThemeManager.shared.current.mainTextColor
        self.font = UIFont.b3Font
    }
}

final class C1LightLabel: UILabel {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.textColor = UIColor.cloudyBlue
        self.font = UIFont.c1Font
    }
}

final class C1Label: UILabel {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.textColor = ColorThemeManager.shared.current.mainTextColor
        self.font = UIFont.c1Font
    }
}
