//
//  CellAndViews.swift
//  SwiftTest
//
//  Created by zhangliang on 2023/2/23.
//  Copyright © 2023 zhangliang. All rights reserved.
//

import UIKit

class CellAndViews: NSObject {

}

class ListCell: UICollectionViewCell {
    static let reuseIdentifier = "list-cell-reuse-identifier"
    let label = UILabel()
    let accessoryImageView = UIImageView()
    let seperatorView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
}

extension ListCell {
    func configure() {
        seperatorView.translatesAutoresizingMaskIntoConstraints = false
        seperatorView.backgroundColor = .lightGray
        contentView.addSubview(seperatorView)

        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: .body)
        contentView.addSubview(label)

        accessoryImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(accessoryImageView)

        selectedBackgroundView = UIView()
        selectedBackgroundView?.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)

        let rtl = effectiveUserInterfaceLayoutDirection == .rightToLeft
        let chevronImageName = rtl ? "chevron.left" : "chevron.right"
        if #available(iOS 13.0, *) {
            let chevronImage = UIImage(systemName: chevronImageName)
            accessoryImageView.image = chevronImage
        }
        
        accessoryImageView.tintColor = UIColor.lightGray.withAlphaComponent(0.7)

        let inset = CGFloat(10)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset),
            label.trailingAnchor.constraint(equalTo: accessoryImageView.leadingAnchor, constant: -inset),

            accessoryImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            accessoryImageView.widthAnchor.constraint(equalToConstant: 13),
            accessoryImageView.heightAnchor.constraint(equalToConstant: 20),
            accessoryImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),

            seperatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            seperatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            seperatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            seperatorView.heightAnchor.constraint(equalToConstant: 0.5)
            ])
    }
}


class TextCell: UICollectionViewCell {
    let label = UILabel()
    static let reuseIdentifier = "text-cell-reuse-identifier"

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError("not implemnted")
    }
}

extension TextCell {
    func configure() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        contentView.addSubview(label)
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        let inset = CGFloat(10)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset)
            ])
    }
}


class BadgeSupplementaryView: UICollectionReusableView {

    static let reuseIdentifier = "badge-reuse-identifier"
    let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    override var frame: CGRect {
        didSet {
            configureBorder()
        }
    }
    override var bounds: CGRect {
        didSet {
            configureBorder()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
}

extension BadgeSupplementaryView {
    func configure() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        label.textColor = .black
        backgroundColor = .green
        configureBorder()
    }
    func configureBorder() {
        let radius = bounds.width / 2.0
        layer.cornerRadius = radius
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1.0
    }
}


class TitleSupplementaryView: UICollectionReusableView {
    let label = UILabel()
    static let reuseIdentifier = "title-supplementary-reuse-identifier"

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension TitleSupplementaryView {
    func configure() {
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        let inset = CGFloat(10)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
            label.topAnchor.constraint(equalTo: topAnchor, constant: inset),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset)
        ])
        label.font = UIFont.preferredFont(forTextStyle: .title3)
    }
}

class SectionBackgroundDecorationView: UICollectionReusableView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
}

extension SectionBackgroundDecorationView {
    func configure() {
        backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 12
    }
}

@available(iOS 13.0, *)
class ConferenceVideoCell: UICollectionViewCell {

    static let reuseIdentifier = "video-cell-reuse-identifier"
    let imageView = UIImageView()
    let titleLabel = UILabel()
    let categoryLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
}

@available(iOS 13.0, *)
extension ConferenceVideoCell {
    func configure() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(categoryLabel)

        titleLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        titleLabel.adjustsFontForContentSizeCategory = true
        categoryLabel.font = UIFont.preferredFont(forTextStyle: .caption2)
        categoryLabel.adjustsFontForContentSizeCategory = true
        categoryLabel.textColor = .placeholderText

        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 1
        imageView.layer.cornerRadius = 4
        imageView.backgroundColor = UIColor.cornflowerBlue

        let spacing = CGFloat(10)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: spacing),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            categoryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            categoryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            categoryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
    }
}

@available(iOS 13.0, *)
class ConferenceNewsFeedCell: UICollectionViewCell {
    static let reuseIdentifier = "conference-news-feed-cell-reuseidentifier"

    let titleLabel = UILabel()
    let dateLabel = UILabel()
    let bodyLabel = UILabel()
    let separatorView = UIView()
    var showsSeparator = true {
        didSet {
            updateSeparator()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

@available(iOS 13.0, *)
extension ConferenceNewsFeedCell {
    func configure() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        separatorView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.adjustsFontForContentSizeCategory = true
        dateLabel.adjustsFontForContentSizeCategory = true
        bodyLabel.adjustsFontForContentSizeCategory = true

        titleLabel.numberOfLines = 0
        bodyLabel.numberOfLines = 0

        titleLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        dateLabel.font = UIFont.preferredFont(forTextStyle: .caption2)
        bodyLabel.font = UIFont.preferredFont(forTextStyle: .body)

        separatorView.backgroundColor = .placeholderText

        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(bodyLabel)
        contentView.addSubview(separatorView)

        let views = ["title": titleLabel, "date": dateLabel, "body": bodyLabel, "separator": separatorView]
        var constraints = [NSLayoutConstraint]()
        constraints.append(contentsOf: NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-[title]-|", options: [], metrics: nil, views: views))
        constraints.append(contentsOf: NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-[date]", options: [], metrics: nil, views: views))
        constraints.append(contentsOf: NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-[body]-|", options: [], metrics: nil, views: views))
        constraints.append(contentsOf: NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-[separator]-|", options: [], metrics: nil, views: views))
        constraints.append(contentsOf: NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-[title]-[date]-[body]-20-[separator(==1)]|",
            options: [], metrics: nil, views: views))
        NSLayoutConstraint.activate(constraints)
        
//        titleLabel.snp.makeConstraints { make in
//            make.left.equalTo(16)
//            make.top.equalTo(10)
//            make.right.equalTo(-20)
//        }
//
//        dateLabel.snp.makeConstraints { make in
//            make.left.equalTo(titleLabel)
//            make.top.equalTo(titleLabel.snp.bottom).offset(8)
//        }
//
//        bodyLabel.snp.makeConstraints { make in
//            make.left.equalTo(titleLabel)
//            make.top.equalTo(dateLabel.snp.bottom).offset(8)
//            make.right.equalTo(-40)
//        }
//
//        separatorView.snp.makeConstraints { make in
//            make.left.equalTo(titleLabel)
//            make.top.equalTo(bodyLabel.snp.bottom).offset(15)
//            make.right.equalTo(-16)
//            make.height.equalTo(1)
//            make.bottom.equalTo(1)
//        }
    }
    func updateSeparator() {
        separatorView.isHidden = !showsSeparator
    }
}

@available(iOS 13.0, *)
class LabelCell: UICollectionViewCell {
    static let reuseIdentifier = "label-cell-reuse-identifier"
    let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
}

@available(iOS 13.0, *)
extension LabelCell {
    func configure() {
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray2.cgColor
        let inset = CGFloat(10)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ])
    }
}

struct Emoji: Hashable {
    enum Category: CaseIterable, CustomStringConvertible {
        case recents, smileys, nature, food, activities, travel, objects, symbols
    }
    
    let text: String
    let title: String
    let category: Category
    private let identifier = UUID()
}

extension Emoji.Category {
    var description: String {
        switch self {
        case .recents: return "Recents"
        case .smileys: return "Smileys"
        case .nature: return "Nature"
        case .food: return "Food"
        case .activities: return "Activities"
        case .travel: return "Travel"
        case .objects: return "Objects"
        case .symbols: return "Symbols"
        }
    }
    
    var emojis: [Emoji] {
        switch self {
        case .recents:
            return [
                Emoji(text: "🤣", title: "Rolling on the floor laughing", category: self),
                Emoji(text: "🥃", title: "Whiskey", category: self),
                Emoji(text: "😎", title: "Cool", category: self),
                Emoji(text: "🏔", title: "Mountains", category: self),
                Emoji(text: "⛺️", title: "Camping", category: self),
                Emoji(text: "⌚️", title: " Watch", category: self),
                Emoji(text: "💯", title: "Best", category: self),
                Emoji(text: "✅", title: "LGTM", category: self)
            ]

        case .smileys:
            return [
                Emoji(text: "😀", title: "Happy", category: self),
                Emoji(text: "😂", title: "Laughing", category: self),
                Emoji(text: "🤣", title: "Rolling on the floor laughing", category: self)
            ]
            
        case .nature:
            return [
                Emoji(text: "🦊", title: "Fox", category: self),
                Emoji(text: "🐝", title: "Bee", category: self),
                Emoji(text: "🐢", title: "Turtle", category: self)
            ]
            
        case .food:
            return [
                Emoji(text: "🥃", title: "Whiskey", category: self),
                Emoji(text: "🍎", title: "Apple", category: self),
                Emoji(text: "🍑", title: "Peach", category: self)
            ]
        case .activities:
            return [
                Emoji(text: "🏈", title: "Football", category: self),
                Emoji(text: "🚴‍♀️", title: "Cycling", category: self),
                Emoji(text: "🎤", title: "Singing", category: self)
            ]

        case .travel:
            return [
                Emoji(text: "🏔", title: "Mountains", category: self),
                Emoji(text: "⛺️", title: "Camping", category: self),
                Emoji(text: "🏖", title: "Beach", category: self)
            ]

        case .objects:
            return [
                Emoji(text: "🖥", title: "iMac", category: self),
                Emoji(text: "⌚️", title: " Watch", category: self),
                Emoji(text: "📱", title: "iPhone", category: self)
            ]

        case .symbols:
            return [
                Emoji(text: "❤️", title: "Love", category: self),
                Emoji(text: "☮️", title: "Peace", category: self),
                Emoji(text: "💯", title: "Best", category: self)
            ]

        }
    }
}
