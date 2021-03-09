//
//  Glideshow.swift
//  Glideshow
//
//  Created by Visal Rajapakse on 2021-02-28.
//

import UIKit

@objc
/// The delegate protocol that notifies slideshow state changes
public protocol GlideshowProtocol : AnyObject {
    
    /// Nofifies delegate that the page has changed
    /// - Parameters:
    ///   - glideshow: Glideshow instance
    ///   - page: The page the slideshow has switched to
    @objc optional func pageDidChange( _ glideshow : Glideshow, didChangePageTo page : Int)
    
    /// Notifies delegate that the slideshow will begin dragging
    /// - Parameter glideshow: Glideshow instance
    @objc optional func glideshowWillBeginDragging( _ glideshow : Glideshow)
    
    /// Notifies delegate that the slideshow finished decelerating
    /// - Parameter glideshow: Glideshow instance
    @objc optional func glideshowDidEndDecelerating( _ glideshow : Glideshow)
    
    /// Notifies delegate if the scrolling Animation finished animating
    /// - Parameter glideshow: Glideshow instance
    @objc optional func glideshowDidFinishingAnimating(_ glideshow : Glideshow)
    
    /// Notifies delegate if the scrollDirection has been changed
    /// - Parameter glideshow: Glideshow instance
    @objc optional func glideshowDidChangeScrollDirection( _ glideshow : Glideshow)
    
    /// Notifies delegate if an item of the slideshow has been selected
    /// - Parameters:
    ///   - indexPath: `IndexPath` of the selected item
    ///   - glideshow: Glideshow instance
    @objc optional func glideshowDidSelecteRowAt(indexPath : IndexPath, _ glideshow : Glideshow)
}


/// Page control location within `Glideshow` by
public enum PageIndicatorPosition{
    case bottom
    case hidden
}

/// Scroll direction of the scrollView
public enum ScrollDirection {
    case left
    case right
}

public class Glideshow: UIView {
    
    /// Reusable cell identifier
    fileprivate let cellReuseIdentifier = "GlideCell"
    
    /// Timer for automatic scroll
    fileprivate var timer : Timer?
    
    /// CollectionView layout
    public var layout = UICollectionViewFlowLayout()
    
    /// CollectionView to wrap content
    public var collectionView : UICollectionView?
    
    /// Slideshow data
    public var items : [GlideItem]? {
        didSet{
            setPageIndicatorIfNeeded()
            layoutSubviews()
            setPagesForIndicator()
            setTimerIfNeeded()
            collectionView?.reloadData()
            initializeCVPositionIfNeeded()
        }
    }
    
    /// Delegate to inform state changes to
    public var delegate : GlideshowProtocol?
    
    /// Time interval to switch slides
    public var interval : Double = 0 {
        didSet{
            setTimerIfNeeded()
        }
    }
    
    /// Margin of the `slide` in `GlideCell`
    public var slideMargin : UIEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20) {
        didSet{
            collectionView?.reloadData()
        }
    }
    
    /// Padding of the content in the `slide` in `GlideCell`
    public var slidePadding : UIEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    
    /// Default slide color
    public var defaultSlideColor : UIColor = UIColor.lightGray
    
    public var placeHolderImage : UIImage?
    
    /// Spacing between `SlideLabels` embedded in the slide
    public var labelSpacing : CGFloat = 8
    
    /// Boolean value to display gradient background in `GlideCell`
    public var isGradientEnabled : Bool = false
    
    /// Slide title font
    public var titleFont : UIFont? = UIFont.systemFont(ofSize: 20, weight: .black)
    
    /// Glide factor of the slide description
    public var descriptionGlideFactor : CGFloat = 3
    
    /// Glide factor of the slide title
    public var titleGlideFactor : CGFloat = 2
    
    /// Glide factor of the slide description
    public var captionGlideFactor : CGFloat = 1
    
    /// Slide desctription font
    public var descriptionFont : UIFont? =  UIFont.systemFont(ofSize: 16, weight: .regular)
    
    /// Slide caption font
    public var captionFont : UIFont? = UIFont.systemFont(ofSize: 14, weight: .light)
    
    /// Slide title text color
    public var titleColor : UIColor = UIColor.white
    
    /// Slide description text color
    public var descriptionColor : UIColor = UIColor.white
    
    /// Slide caption text color
    public var captionColor : UIColor = UIColor.white

    /// Color of the `GlideCell` background gradient
    public var gradientColor : UIColor = UIColor.black.withAlphaComponent(0.6) {
        didSet{
            if oldValue != gradientColor {
                isGradientEnabled = true
            }
        }
    }
    
    /// Height of the gradient compared to the `Slide` height
    public var gradientHeightFactor : CGFloat = 0.5 {
        didSet {
            if oldValue != gradientHeightFactor {
                isGradientEnabled = true
            }
        }
    }
    
    /// Page indicator
    public var pageIndicator : UIPageControl? {
        didSet{
            setPagesForIndicator()
            setPageIndicatorIfNeeded()
        }
    }
    
    /// Page indicator position
    public var pageIndicatorPosition : PageIndicatorPosition = .hidden{
        didSet{
            setPageIndicatorIfNeeded()
        }
    }
    
    /// Scrolls to start/end of the collectionView if slideshow is circular
    lazy var currentIndex : Int = collectionView?.indexPathsForVisibleItems.sorted().first?.last ?? 0 - 1
    
    /// Current slide page
    private var pageByMidSection : Int = 0 {
        didSet{
            if pageByMidSection != oldValue {
                delegate?.pageDidChange?(self, didChangePageTo: ((pageByMidSection) % items!.count) + 1)
            }
        }
    }
    
    /// Current page in the slideshow
    public var currentPage : Int {
        get {
            return !(items?.isEmpty ?? false) ? ((pageByMidSection + 1) % items!.count) + 1 : 0
        }
    }
    
    /// Value to check if the collection view should be rotateable/circular
    public var isCircular : Bool = true{
        didSet{
            setTimerIfNeeded()
        }
    }
    
    /// Last noted scrollDirection calculated using `lastContentOffset`
    private var scrollDirection: ScrollDirection = .left {
        didSet{
            if scrollDirection != oldValue {
                delegate?.glideshowDidChangeScrollDirection?(self)
            }
        }
    }
    
    /// Visible cells of the collectionview cell that conform to `GlideableCellDelegate` for hiding/showing content
    private var firstCell : GlideableCellDelegate!
    private var lastCell : GlideableCellDelegate!
    
    /// tag of the first cell
    private var firstCellTag : Int!
    
    /// calculated offset determining the offset of the label, mainly to translate the cell in a cirular manner
    private var relativeOffset : CGFloat!
    
    /// Stores offset of the scrollview for animating
    fileprivate var offset : CGFloat!
    
    /// Stores the width of the CollectionView
    fileprivate var width : CGFloat!
    
    /// Stores the value of half the width of the CollectionView
    fileprivate var widthHalf : CGFloat!
    
    /// Stores value of the full-sections passed
    fileprivate var currentMidSectionCount : CGFloat! = 0{
        didSet{
            intCurrentMidSection = Int(currentMidSectionCount)
        }
    }
    
    /// Stores value of the full-sections passed as an integer
    private var intCurrentMidSection : Int!

    // Stores position/offset of a cell rounded to the closest width
    fileprivate var position : CGFloat = 0
        
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    private func initialize(){
        // View configuration
        clipsToBounds = true
        autoresizesSubviews = true
        
        // Collection view layout configuration
        layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        // Collection view configuration
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.isPagingEnabled = true
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        collectionView?.clipsToBounds = true
        collectionView?.backgroundColor = .clear
        
        if pageIndicator == nil {
            pageIndicator = UIPageControl()
            pageIndicator?.pageIndicatorTintColor = UIColor.lightGray
            pageIndicator?.currentPageIndicatorTintColor = UIColor.darkGray
            self.addSubview(pageIndicator!)
        }
        
        // Adding subview
        addSubview(collectionView!)
        
        registerGlideCell()
        setTimerIfNeeded()

    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        setupCollectionView()
        setCurrentPage()
        setPageIndicatorIfNeeded()
        initializeCVPositionIfNeeded()
    }
        
    /// Registers cell of type GlideCell to the CollectionView
    private func registerGlideCell(){
        collectionView?.register(GlideCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
    }
    
    /// Setting current page based on the `currentMidSectionCount`
    private func setCurrentPage(){
        if items == nil || (items?.isEmpty ?? false)  { return }

        let page = Int((currentMidSectionCount).rounded())
        pageByMidSection = (page) % items!.count
        pageIndicator?.currentPage = pageByMidSection
    }
    
    public func log(message : String){
        print("Glideshow", message)
    }
    
    /// Jumps to a provided slide
    /// - Parameters:
    ///   - slide: Int value of the slide to jump or transition to
    ///   - animated: if `true` it animates the process of jumping
    public func jumpToSlide(_ slide : Int, _ animated : Bool = true){
        invalidateTimer()
        let pageToJump = (33 * items!.count) + slide - 1
        if slide > items?.count ?? 0 {return}
        collectionView?.scrollToItem(at: IndexPath(item: pageToJump, section: 0), at: .right, animated: animated)
        setTimerIfNeeded()
    }
    
    /// Animates first visble cell by hiding/showing content
    fileprivate func animateFirstCell(){
        guard firstCell != nil && lastCell != nil else { return }
        lastCell.isProminent = false
        firstCell.isProminent = true
    }
    
    /// Animates last visible cell by hiding/showing content
    fileprivate func animateLastCell(){
        guard firstCell != nil && lastCell != nil else { return }
        firstCell.isProminent = false
        lastCell.isProminent = true
    }
    
    fileprivate func animateAllCells(){
        guard firstCell != nil && lastCell != nil else { return }
        firstCell.isProminent = true
        lastCell.isProminent = true
    }
    
    /// Invalidates timer on function call
    fileprivate func invalidateTimer(){
        timer?.invalidate()
    }
    
    /// Sets timer if the conditions are satisfied
    fileprivate func setTimerIfNeeded() {
        timer?.invalidate()
        timer = nil
        if interval > 0 && (items?.count ?? 0) > 1 && timer == nil && isCircular{
            timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(animateSlideWithTime(_:)), userInfo: nil, repeats: true)
        }
    }
    
    
    /// Animates Glideshow slides
    /// - Parameter timer: `Timer` that invokes the function
    @objc fileprivate func animateSlideWithTime(_ timer : Timer?){
        let currentPage = Int(round(offset/width))
        collectionView?.scrollToItem(
            at: IndexPath(
                item: (currentPage + 1),
                section: 0
            ),
            at: .left,
            animated: true)

    }
    
    /// Setup attributes of the collectionView upon laying out subviews
    fileprivate func setupCollectionView(){
        collectionView?.frame = self.bounds
        width = collectionView?.frame.width
        offset = collectionView?.contentOffset.x
        widthHalf = width / 2
    }
    
    
    /// Initializes and positions sets cells to the mid value
    func initializeCVPositionIfNeeded(){
        collectionView?.layoutIfNeeded()
        if items?.count != 0 && items != nil && isCircular{
            collectionView?.scrollToItem(at: IndexPath(item: 33 * items!.count, section: 0), at: .right, animated: false)
        }
    }
    
    /// setting number of pages, current page for the page control
    fileprivate func setPagesForIndicator(){
        if items == nil { return }
        pageIndicator?.numberOfPages = items!.count
        pageIndicator?.currentPage = pageByMidSection
    }
    
    fileprivate func setPageIndicatorIfNeeded(){
        if self.width == nil { return }
        
        switch pageIndicatorPosition {
        case .hidden:
            
            collectionView?.frame = self.bounds
        case .bottom:
            slideMargin.bottom = 10
            collectionView?.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.height - 10)
            pageIndicator!.frame = CGRect(x: 0, y: self.frame.height - 10, width: width, height: 10)
        }
        collectionView?.reloadData()
        self.layoutIfNeeded()
    }
    
    
    /// Calculates scrollview scroll direction based on current offset + previously recorded offset
    /// - Parameter offset: Current offset of the scrollview for comparison
    func setScrollDirection(offset : CGFloat){
        if (self.offset > offset) {
            scrollDirection = .right
        }
        else if (self.offset < offset) {
            scrollDirection = .left
        }
        self.offset = offset
        
    }
    
    /// Sorts visible cells based on cell tags and assigns cells as `firstCell`, `lastCell`
    /// - Returns: Array of `GlideCells`
    func sortCellsByTags() -> [GlideCell] {
        /// Sorting the visible cells by `cellTag` and casting sorted `UICollectionViewCell` array to `GlideableCellDelegate` to access `cellTag` property
        let sortedCellsByTag = collectionView?.visibleCells.sorted(by: { firstCell, lastCell -> Bool in
            let leadingCell = firstCell as! GlideCell
            let trailingCell = lastCell as! GlideCell
            return leadingCell.tag < trailingCell.tag
        }) as! [GlideCell]
        // Setting first, last visible cells based on visible cells in the collectionview
        lastCell = sortedCellsByTag.last
        firstCell = sortedCellsByTag.first
        
        return sortedCellsByTag
    }
    
    /// Changes page if necessary based on position/offset of the `CurrentIndex`
    private func changePageIfNeeded(){
        currentIndex = Int((currentMidSectionCount).rounded())
        
        let realPage = (currentIndex % items!.count)
        if (currentIndex < (33 * items!.count) - 5) || (currentIndex > (33 * items!.count) + 5) {
            collectionView?.scrollToItem(
                at: IndexPath(
                    item: (33 * items!.count ) + realPage,
                    section: 0
                ),
                at: .centeredVertically,
                animated: false)
        }
    }
}

//MARK: Extensions - UICollectionView + UIScrollView
/// Conformance to protocols of UICollectionView
extension Glideshow : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (items?.count ?? 0) * (isCircular ? 55 : 1)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Cell setup
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: cellReuseIdentifier,
                for: indexPath
        ) as? GlideCell else { return UICollectionViewCell()}
        

        // GlideCell configuration
        cell.tag = indexPath.row
        // Slide labels
        cell.titleFont = titleFont
        cell.captionFont = captionFont
        cell.descriptionFont = descriptionFont
        cell.slideTitle.textColor = titleColor
        cell.slideDescription.textColor = descriptionColor
        cell.slideCaption.textColor = captionColor
        cell.slideTitle.glideFactor = titleGlideFactor
        cell.slideDescription.glideFactor = descriptionGlideFactor
        cell.slideCaption.glideFactor = captionGlideFactor
        cell.labelSpacing = labelSpacing
        cell.slide.backgroundColor = defaultSlideColor
        // layout
        cell.layoutMargins = slideMargin
        cell.slide.layoutMargins = slidePadding
        if isGradientEnabled {
            cell.isGradientEnabled = isGradientEnabled
            cell.gradientColor = gradientColor
            cell.gradientHeightFactor = gradientHeightFactor
        }
        /// Cell setup for passed `GlideItems`
        if let item = items?[indexPath.item % (items?.count ?? 0)] {
            cell.configure(
                with: item,
                placeholderImage: placeHolderImage
            )
        }
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        /// Setting scrollDirection
        setScrollDirection(offset: scrollView.contentOffset.x)
        setCurrentPage()
        /// Setting offset for calculations
        offset = collectionView?.contentOffset.x ?? 0
        currentMidSectionCount = (offset/width).rounded()
        position = collectionView?.collectionViewLayout.layoutAttributesForItem(at: IndexPath(row: Int(currentMidSectionCount), section: 0))?.frame.origin.x ?? 0
        
        /// Relative offset for label translation calculations
        relativeOffset = position - offset
        /// `tag` of first cell in the sorted collectionview visible cells array
        firstCellTag = sortCellsByTags().first?.tag
        

        /// Setting visibility of cell content based on current midsection
        if intCurrentMidSection == firstCellTag {
            animateFirstCell()
        } else {
            animateLastCell()
        }

        /// Animating all cells conforming to `GlideableCellDelegate`
        collectionView?.visibleCells.forEach{
            if let glideable = $0 as? GlideableCellDelegate{
                glideable.cellDidGlide(offset: relativeOffset)
            }
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        setCurrentPage()
        animateAllCells()
        delegate?.glideshowDidEndDecelerating?(self)
    }
    
    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        setCurrentPage()
    }
        
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        invalidateTimer()
        setCurrentPage()
        delegate?.glideshowWillBeginDragging?(self)
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        setCurrentPage()
        animateAllCells()
        changePageIfNeeded()
        delegate?.glideshowDidFinishingAnimating?(self)
    }
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        setCurrentPage()
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        setTimerIfNeeded()
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.glideshowDidSelecteRowAt?(indexPath: indexPath, self)
    }
}
